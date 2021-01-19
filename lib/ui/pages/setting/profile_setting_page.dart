import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/model/setting/storage_param_model.dart';
import 'package:circle/core/model/setting/storage_result_model.dart';
import 'package:circle/core/model/user/update_user_info_param_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:circle/core/services/Image_util.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/core/services/size_fit.dart';
import 'package:circle/ui/pages/setting/setting_bio_page.dart';
import 'package:circle/ui/pages/setting/setting_gender_page.dart';
import 'package:circle/ui/pages/setting/setting_user_name_page.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:crypto/crypto.dart';
import 'package:circle/core/extension/navigator_extension.dart';

class ProfileSettingPage extends StatefulWidget {
  @override
  _ProfileSettingPageState createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  List<Widget> _elements = [];

  @override
  void initState() {
    super.initState();
    _configData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('修改资料', style: Theme.of(context).textTheme.headline1,),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
                child: InkWell(
                  onTap: (){
                    ImageUtil.getGalleryImage().then((PickedFile imageFile) {
                      if (imageFile != null) {
                        _uploadAvatar(imageFile);
                      } else {
                        print('No image selected.');
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(width: 0.5, color: Color(0xffe5e5e5)))
                    ),
                    height: 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Selector<UserViewModel, Avatar>(
                            selector: (context, userVM) => userVM.avatar,
                            shouldRebuild: (prev, next) {
                              return prev != next;
                            },
                            builder: (context, avatar, child) {
                              return Container(
                                width: 100.px,
                                height: 100.px,
                                child:ClipOval(child: avatar == null ? Image.asset('assets/images/default_avatar.png') : CachedNetworkImage(imageUrl:avatar.url)),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
            ),
            SliverList(delegate: SliverChildBuilderDelegate((context, index) => _elements[index],
                childCount: _elements.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _configData(){
    _elements = [
      Selector<UserViewModel, String>(
          selector: (context, userVM) => userVM.name,
          shouldRebuild: (prev, next) => prev != next,
          builder: (context, name, child) {
            return _getRow('名字', name, () {
                NavigatorExt.pushToPage(context, SettingUserNamePage(), fullscreenDialog: true);
              });
          }),

      Selector<UserViewModel, String>(
          selector: (context, userVM) => userVM.bio,
          shouldRebuild: (prev, next) => prev != next,
          builder: (context, bio, child) {
            return _getRow('个性签名', bio, () {
                NavigatorExt.pushToPage(context, SettingBioPage(), fullscreenDialog: true);
              });
          }),


      Selector<UserViewModel, int>(
          selector: (context, userVM) => userVM.sex,
          shouldRebuild: (prev, next) => prev != next,
          builder: (context, gender, child) {
            return _getRow('性别', gender == 0 ? '女' : '男', () {
                NavigatorExt.pushToPage(context, SettingGenderPage(), fullscreenDialog: true);
              });
          }),


      Selector<UserViewModel, String>(
          selector: (context, userVM) => userVM.location,
          shouldRebuild: (prev, next) => prev != next,
          builder: (context, location, child) {
            return _getRow('位置', location, () {
                NavigatorExt.pushToPage(context, SettingBioPage(), fullscreenDialog: true);
              });
          }),
    ];
  }

  Widget _getRow(String title, String subTitle, VoidCallback callback){
    return InkWell(
      onTap: callback,
      child: Container(
        constraints:BoxConstraints(
          minHeight: 45.px,
        ),
//        height: 45.px,
        padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 8.px),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 0.5, color: Color(0xffe5e5e5)))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title),
            SizedBox(width: 20.px),
            Expanded(
                child: Text(subTitle, textAlign: TextAlign.right,)
            )
          ],
        ),
      ),
    );
  }

  void _uploadAvatar(PickedFile originalImageFile) async {
    if (originalImageFile == null || originalImageFile.path.isEmpty) {
      return;
    }

    File imageFile = await ImageCropper.cropImage(
        sourcePath: originalImageFile.path,
        aspectRatio: CropAspectRatio(ratioY: CIRSizeFit.screenWidth, ratioX: CIRSizeFit.screenWidth),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: true,
        )
    );

    if (imageFile == null || imageFile.path.isEmpty) {
      return;
    }

    File file = File(imageFile.path);
    int fileSize = await file.length();
    String fileName = imageFile.path.split("/").last;
    String mimeType = _getMediaType('.${fileName.split(".").last}');

    Uint8List imageFileBytes = await imageFile.readAsBytes();
    String hashString = md5.convert(imageFileBytes).toString();

    StorageParamModel param = StorageParamModel(
      filename: fileName,
      hash: hashString,
      size: fileSize,
      mimeType: mimeType,
      storage: Storage(channel: 'public'),
    );
    StorageResultModel storageResult;
    await GetDataTool.storage(param, (value) {
      storageResult = value;
    });
    await GetDataTool.uploadFileToStorage(storageResult.uri, storageResult.method, storageResult.headers.toJson(), imageFileBytes, (value) { });
    UpdateUserInfoParamModel updateUserInfoParam = UpdateUserInfoParamModel();
    updateUserInfoParam.avatar = storageResult.node;
    await GetDataTool.updateUserInfo(updateUserInfoParam, (value) {
      if(value){
        context.read<UserViewModel>().setAvatar(Avatar(url: storageResult.uri));
      }
    });
  }

  String _getMediaType(final String fileExt) {
    switch (fileExt.toLowerCase()) {
      case ".jpg":
      case ".jpeg":
      case ".jpe":
        return "image/jpeg";
      case ".png":
        return "image/png";
      case ".bmp":
        return "image/bmp";
      case ".gif":
        return "image/gif";
      case ".json":
        return "application/json";
      case ".svg":
      case ".svgz":
        return "image/svg+xml";
      case ".mp3":
        return "audio/mpeg";
      case ".mp4":
        return "video/mp4";
      case ".mov":
        return "video/mov";
      case ".htm":
      case ".html":
        return "text/html";
      case ".css":
        return "text/css";
      case ".csv":
        return "text/csv";
      case ".txt":
      case ".text":
      case ".conf":
      case ".def":
      case ".log":
      case ".in":
        return "text/plain";
    }
    return '';
  }
}
