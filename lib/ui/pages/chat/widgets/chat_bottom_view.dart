import 'dart:io';
import 'dart:math';
import 'package:circle/core/provider/chat_view_model.dart';
import 'package:circle/core/provider/voice_record_provider.dart';
import 'package:circle/core/services/Image_util.dart';
import 'package:circle/core/services/permission_util.dart';
import 'package:circle/ui/pages/chat/widgets/record_voice_item.dart';
import 'package:circle/ui/pages/chat/widgets/voice_record_item.dart';
import 'package:circle/ui/shared/dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flutter_plugin_record/index.dart';
import 'package:photo/photo.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo/src/ui/page/photo_main_page.dart';
import 'package:photo/src/provider/selected_provider.dart';
import 'package:photo/src/provider/asset_provider.dart';
import 'package:photo/src/entity/options.dart';
import 'package:permission_handler/permission_handler.dart';

typedef onItemClick = void Function(Object); //控件点击时触发
typedef sendTextCallback = void Function(String contentText);
typedef sendVoiceCallback = void Function(String filePath, double timeLength);
typedef sendImageCallback = void Function(String filePath, bool sendOriginalImage );
typedef sendVideoCallback = void Function(String filePath, int timeLength);

class ChatBottomView extends StatefulWidget {
  final sendTextCallback sendTextHandle;
  final sendVoiceCallback sendVoiceCallHandle;
  final sendImageCallback sendImageCallHandle;
  final sendVideoCallback sendVideoCallHandle;

  const ChatBottomView({Key key, this.sendTextHandle, this.sendVoiceCallHandle, this.sendImageCallHandle, this.sendVideoCallHandle}) : super(key: key);

  @override
  _ChatBottomViewState createState() => _ChatBottomViewState();
}

class _ChatBottomViewState extends State<ChatBottomView> with LoadingDelegate, SelectedProvider{
  bool isVoiceRecord = false;
  VoiceRecordProvider voiceRecordProvider;
  TextEditingController _inputTextEditingController = TextEditingController();
  FocusNode _inputFocusNode = FocusNode();
  List<Widget> _guideToolsList = [];
  List<AssetEntity> imageDataList = List<AssetEntity>();
  final AssetProvider assetProvider = AssetProvider();

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          isVoiceRecord = false;
          context.read<ChatViewModel>().hiddenEmojiBarAndExtensionBar();
          this.setState(() { });
//          try {
//            _scrollController.position.jumpTo(0);
//          } catch (e) {}
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    context.read<ChatViewModel>().hiddenEmojiBarAndExtensionBar();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          _inputBar(context),
          Selector<ChatViewModel, bool>(
              selector: (ctx, chatVM) => chatVM.isShowEmojiBar,
              shouldRebuild: (prev, next) {
                return next != prev;
              },
              builder: (ctx, isShowEmojiBar, child) {
                if(isShowEmojiBar) {
                  return _emojiPicker(context);
                }
                return Container();
              }),

          Selector<ChatViewModel, bool>(
              selector: (ctx, chatVM) => chatVM.isShowExtensionBar,
              shouldRebuild: (prev, next) {
                return next != prev;
              },
              builder: (ctx, isShowExtensionBar, child) {
                if(isShowExtensionBar) {
                  return _toolsWidget(context);
                }
                return Container();
              }),

//          if(context.select<ChatViewModel>().isShowEmojiBar) _emojiPicker(context),
//          if(context.select<ChatViewModel>().isShowExtensionBar) _toolsWidget(context),
        ]
    );
  }

  Widget _inputBar(BuildContext context){
    return Row(
      children: <Widget>[
        SizedBox(width: 8.px),
        Transform.rotate(
            angle: isVoiceRecord ? 0 : pi / 2,
            child: OutlinedIconButton(
              icon: isVoiceRecord ? Icon(Icons.keyboard, color: Colors.black,) : Icon(Icons.wifi, color: Colors.black,),
              onTap: () async {
                isVoiceRecord = !isVoiceRecord;
                context.read<ChatViewModel>().hiddenEmojiBarAndExtensionBar();
                this.setState(() {});
                if (isVoiceRecord){
                  _inputFocusNode.unfocus();
                  PermissionUtil.requestPermission(Permission.microphone);
                }else{
                  FocusScope.of(context).requestFocus(_inputFocusNode);
                }
//                  voiceRecordProvider.updateVoiceRecord();
              },
            )),
        SizedBox(width: 10.px),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.px),
                  constraints: BoxConstraints(
                    maxHeight: 120.0.px,
                  ),
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.send,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    autocorrect: false,
                    controller: _inputTextEditingController,
                    focusNode: _inputFocusNode,
                    onSubmitted: (String content) {
                      if(content.length > 0) {
                        FocusScope.of(context).requestFocus(_inputFocusNode);
                        _inputTextEditingController.clear();
                        widget.sendTextHandle(content);
                      }
                    },
                  )),
              if(isVoiceRecord) VoiceWidget(
                  startRecord: (){},
                  stopRecord: (String path, double audioTimeLength){
                    print("结束束录制");
                    print("音频文件位置"+path);
                    print("音频录制时长"+audioTimeLength.toString());
                    widget.sendVoiceCallHandle(path, audioTimeLength);
                  }
              )
            ],
          ),
        ),
        SizedBox(width: 10.px),
        Selector<ChatViewModel, bool>(
            selector: (ctx, chatVM) => chatVM.isShowEmojiBar,
            shouldRebuild: (prev, next) => next != prev,
            builder: (ctx, isShowEmojiBar, child) {
              return OutlinedIconButton(
                icon: isShowEmojiBar ? Icon(Icons.keyboard, color: Colors.black) : Icon(Icons.face, color: Colors.black),
                onTap: () async {
                  if (!isShowEmojiBar){
                    _inputFocusNode.unfocus();
                  }else{
                    FocusScope.of(context).requestFocus(_inputFocusNode);
                  }
                  isVoiceRecord = false;
                  this.setState(() { });
                  context.read<ChatViewModel>().isShowEmojiBar = !isShowEmojiBar;
                },
              );
            }),
        SizedBox(width: 8.px),
        Selector<ChatViewModel, ChatViewModel>(
            selector: (ctx, chatVM) => chatVM,
            shouldRebuild: (prev, next) => next.isShowExtensionBar != prev.isShowExtensionBar,
            builder: (ctx, chatVM, child) {
              return OutlinedIconButton(
                icon: Icon(Icons.add, color: Colors.black),
                onTap: () {
                  bool isShowExtensionBar = chatVM.isShowExtensionBar;
                  if (!isShowExtensionBar){
                    _inputFocusNode.unfocus();
                  }else{
                    FocusScope.of(context).requestFocus(_inputFocusNode);
                  }
                  isVoiceRecord = false;
                  this.setState(() { });
                  chatVM.isShowExtensionBar = !isShowExtensionBar;
                },
              );
            }),
        SizedBox(width: 8.px),
      ],
    );
  }

  Widget _emojiPicker(BuildContext context) {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: ["racing", "horse"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        _inputTextEditingController.text = _inputTextEditingController.text + emoji.emoji;
      },
    );
  }

  _toolsWidget(BuildContext context) {
    if (_guideToolsList.length > 0) {
      _guideToolsList.clear();
    }
    List<Widget> _widgets = new List();
    _widgets.add(_buildIcon(Icons.insert_photo, '相册', o: (res) {
       _pickAsset();
       context.read<ChatViewModel>().isShowExtensionBar = false;
//      return ImageUtil.getGalleryImage().then((imageFile) {
//        if (imageFile != null) {
//          _willBuildImageMessage(imageFile);
//        } else {
//          print('No image selected.');
//        }
//      });
    }));
    _widgets.add(_buildIcon(Icons.camera_alt, '拍摄', o: (res) {
//      return ImageUtil.showCameraChosen(context, onCallBack: (type, file) {
//        if (type == 1) {
//          //相机取图片
//          if (file != null) {
//            _willBuildImageMessage(File(file.path));
//          } else {
//            print('No image selected.');
//          }
//        } else if (type == 2) {
//          //相机拍视频
//          return _buildVideoMessage(file);
//        }
//      });
    }));
    _widgets.add(_buildIcon(Icons.videocam, '视频通话'));
    _widgets.add(_buildIcon(Icons.location_on, '位置'));
//    _widgets.add(_buildIcon(Icons.view_agenda, '红包'));
//    _widgets.add(_buildIcon(Icons.swap_horiz, '转账'));
//    _widgets.add(_buildIcon(Icons.mic, '语音输入'));
//    _widgets.add(_buildIcon(Icons.favorite, '我的收藏'));
    _guideToolsList.add(GridView.count(
        crossAxisCount: 4, padding: EdgeInsets.all(0.0), children: _widgets));

//    List<Widget> _widgets1 = new List();
//    _widgets1.add(_buildIcon(Icons.person, '名片'));
//    _widgets1.add(_buildIcon(Icons.folder, '文件'));
//
//    _guideToolsList.add(GridView.count(
//        crossAxisCount: 4, padding: EdgeInsets.all(0.0), children: _widgets1));

    return Container(
      height: 180.px,
      child: Swiper(
          autoStart: false,
          circular: false,
          children: _guideToolsList,
          indicator: CircleSwiperIndicator(
              radius: 3.0,
              padding: EdgeInsets.only(top: 10.0, bottom: 10),
              itemColor: Colors.grey,
              itemActiveColor: Colors.blue)
      ),
    );
  }

  Widget _buildIcon(IconData icon, String text, {onItemClick o}) {
    return Column(
      children: <Widget>[
        SizedBox(height: 8),
        InkWell(
            onTap: () {
              if (null != o) {
                o(null);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                decoration: BoxDecoration(

                ),
                width: 54,
                height: 54,
                child: Icon(icon, size: 28, color: Colors.black),
              ),
            )),
        SizedBox(height: 5),
        Text(text, style: TextStyle(fontSize: 12),),
      ],
    );
  }

  _willBuildImageMessage(imageFile) {
    if (imageFile == null || imageFile.path.isEmpty) {
      return;
    }
    DialogUtil.showBaseDialog(context, '是否发送原图？', title: '',
        right: '原图', left: '压缩图',
        rightClick: () {
          widget.sendImageCallHandle(imageFile.path, true);
        },
        leftClick: () {
          widget.sendImageCallHandle(imageFile.path, false);
        });
  }

  _buildImageMessage(File file, bool sendOriginalImage) {
//    MessageEntity messageEntity = new MessageEntity(
//        type: Constants.MESSAGE_TYPE_CHAT,
//        senderAccount: widget.senderAccount,
//        titleName: widget.senderAccount,
//        content: '',
//        sendOriginalImage: sendOriginalImage,
//        time: new DateTime.now().millisecondsSinceEpoch.toString());
//    messageEntity.imageUrl = ''; //这里可以加上头像的url，不过对方和自己的头像目前都是取assets中固定的
//    messageEntity.contentUrl = file.path;
//    messageEntity.messageOwner = 0;
//    messageEntity.status = '2';
//    messageEntity.contentType = Constants.CONTENT_TYPE_IMAGE;
//    setState(() {
//      _messageList.insert(0, messageEntity);
//      _controller.clear();
//    });
//    _sendMessage(messageEntity);
  }

  _buildVideoMessage(Map file) {
//    MessageEntity messageEntity = new MessageEntity(
//        type: Constants.MESSAGE_TYPE_CHAT,
//        senderAccount: widget.senderAccount,
//        titleName: widget.senderAccount,
//        content: '',
//        time: new DateTime.now().millisecondsSinceEpoch.toString());
//    messageEntity.imageUrl = ''; //这里可以加上头像的url，不过对方和自己的头像目前都是取assets中固定的
//    messageEntity.contentUrl = file['videoPath'];
//    messageEntity.thumbPath = file['thumbPath'];
//    messageEntity.messageOwner = 0;
//    messageEntity.length = int.parse(file['length']) + 1;
//    messageEntity.status = '2';
//    messageEntity.contentType = Constants.CONTENT_TYPE_VIDEO;
//    setState(() {
//      _messageList.insert(0, messageEntity);
//      _controller.clear();
//    });
//    _sendMessage(messageEntity);
  }

  void _pickAsset({List<AssetPathEntity> pathList}) async {
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      // BuildContext required
      context: context,
      /// The following are optional parameters.
      themeColor: Colors.white,
      // the title color and bottom color
      textColor: Colors.black,
      // text color
      padding: 3.0,
      // item padding
      dividerColor: Colors.white10,
      // divider color
      disableColor: Colors.grey[50],
      // the check box disable color
      itemRadio: 0.88,
      // the content item radio
//      maxSelected: 9,
      // max picker image count
      // provider: I18nProvider.english,
      provider: I18nProvider.chinese,
      // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      rowCount: 4,
      // item row count
      thumbSize: 150,
      // preview thumb size , default is 64
      sortDelegate: SortDelegate.common,
      // default is common ,or you make custom delegate to sort your gallery
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.yellow,
        unselectedColor: Colors.grey,
        checkColor: Colors.yellow,
      ),
      // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox
      loadingDelegate: this,
      // if you want to build custom loading widget,extends LoadingDelegate, [see example/lib/main.dart]
      badgeDelegate: const DurationBadgeDelegate(),
      // badgeDelegate to show badge widget
      pickType: PickType.all,
      photoPathList: pathList,
//      pickedAssetList: imageDataList,
//      checkBoxSelectedColor: Colors.yellow,
    );

    if (imgList == null || imgList.isEmpty) return;
    imageDataList = imgList;
    assetProvider.current = AssetPathEntity();
    if (imageDataList.length > 0) {
      for (AssetEntity e in imageDataList) {
        File file = await e.file;
        if(e.type == AssetType.image) {
          widget.sendImageCallHandle(file.path, true);
        } else {
          widget.sendVideoCallHandle(file.path, e.videoDuration.inMilliseconds);
        }
      }
    }
  }
  
  @override
  Widget buildBigImageLoading(
      BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 50.0,
        height: 50.0,
        child: CupertinoActivityIndicator(
          radius: 25.0,
        ),
      ),
    );
  }

  @override
  Widget buildPreviewLoading(
      BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 50.0,
        height: 50.0,
        child: CupertinoActivityIndicator(
          radius: 25.0,
        ),
      ),
    );
  }

  @override
  bool isUpperLimit() {
    // TODO: implement isUpperLimit
    throw UnimplementedError();
  }

  @override
  void sure() {
    // TODO: implement sure
  }
}

class OutlinedIconButton extends StatelessWidget {
  const OutlinedIconButton({Key key, @required this.icon, @required this.onTap})
      : super(key: key);
  final Icon icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
        width: 60 * rpx,
        margin: EdgeInsets.all(10 * rpx),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 4 * rpx)),
        child: IconButton(
          splashColor: Colors.transparent,
          icon: icon,
          iconSize: 40 * rpx,
          padding: EdgeInsets.all(0),
          onPressed: onTap,
        ));
  }
}