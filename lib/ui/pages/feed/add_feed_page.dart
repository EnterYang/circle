import 'dart:io' show File;
import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/feed/add_feed_param_model.dart';
import 'package:circle/core/model/feed/add_feedl_param_cell_model.dart';
import 'package:circle/core/model/group/add_post_param_model.dart';
import 'package:circle/core/model/upload_file_result_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/core/services/http_util.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/widgets/follow_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo/src/ui/page/photo_main_page.dart';
import 'package:photo/src/provider/selected_provider.dart';
import 'package:photo/src/provider/asset_provider.dart';
import 'package:photo/src/entity/options.dart';

class AddFeedPage extends StatefulWidget {
  AddFeedPage({Key key}) : super(key: key);

  @override
  _AddFeedPageState createState() => _AddFeedPageState();
}

class _AddFeedPageState extends State<AddFeedPage> with LoadingDelegate, SelectedProvider{
  List<AssetEntity> imageDataList = List<AssetEntity>();
  String _error = 'No Error Dectected';
  final AssetProvider assetProvider = AssetProvider();
  final contentTextEditingController = TextEditingController();
  int selectedGroupId = 0;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    contentTextEditingController.dispose();
    super.dispose();
  }
  Widget buildGridView() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GridView.builder(
        // controller: scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: 3,
        ),
        itemBuilder: _buildItem,
        itemCount: imageDataList.length,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    var data = imageDataList[index];
    return RepaintBoundary(
      child: GestureDetector(
        // onTap: _onTapPreview,
        child: Stack(
          children: <Widget>[
            ImageItem(
              entity: data,
              size: 150,
            ),
            _buildSelected(data),
          ],
        ),
      ),
    );
  }
  bool handlePreviewResult(List<AssetEntity> v) {
    if (v == null) {
      return false;
    }
    if (v is List<AssetEntity>) {
      return true;
    }
    return false;
  }

  Widget _buildSelected(AssetEntity entity) {
    var currentSelected = containsEntity(entity);
    return Positioned(
      right: 0.0,
      width: 36.0,
      height: 36.0,
      child: GestureDetector(
        onTap: () {
          imageDataList.removeWhere((element) => entity == element );
          setState(() {});
          // changeCheck(!currentSelected, entity);
        },
        behavior: HitTestBehavior.translucent,
        child: _buildText(entity),
      ),
    );
  }
  Widget _buildText(AssetEntity entity) {
    var isSelected = containsEntity(entity);
    Widget child;
    BoxDecoration decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: Colors.white,
        ),
        color: Colors.black.withOpacity(0.5),
      );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: decoration,
        alignment: Alignment.center,
        child: Icon(Icons.close, color: Colors.white, size: 12,),
      ),
    );
  }
  // void _onTapPreview() async {
  //   var result = PhotoPreviewResult();
  //   // isPushed = true;
  //   var v = await Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (ctx) => PhotoPickerProvider(
  //         provider: I18nProvider.chinese,
  //         options: Options(
  //           themeColor: Colors.white,
  //           // the title color and bottom color
  //           textColor: Colors.black,
  //           // text color
  //           padding: 3.0,
  //           // item padding
  //           dividerColor: Colors.white10,
  //           // divider color
  //           disableColor: Colors.grey[50],
  //           // the check box disable color
  //           itemRadio: 0.88,
  //           // the content item radio
  //           maxSelected: 9,
  //           // max picker image count
  //           // provider: I18nProvider.english,
  //           // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
  //           rowCount: 4,
  //           // item row count
  //           thumbSize: 150,
  //           // preview thumb size , default is 64
  //           sortDelegate: SortDelegate.common,
  //           // default is common ,or you make custom delegate to sort your gallery
  //           checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
  //             activeColor: Colors.yellow,
  //             unselectedColor: Colors.grey,
  //             checkColor: Colors.yellow,
  //           ),
  //           // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox
  //           loadingDelegate: this,
  //           // if you want to build custom loading widget,extends LoadingDelegate, [see example/lib/main.dart]
  //           badgeDelegate: const DurationBadgeDelegate(),
  //           // badgeDelegate to show badge widget
  //           checkBoxSelectedColor: Colors.yellow,
  //         ),
  //         child: PhotoPreviewPage(
  //           selectedProvider: this,
  //           list: List.of(imageDataList),
  //           changeProviderOnCheckChange: false,
  //           result: result,
  //           isPreview: true,
  //           assetProvider: assetProvider,
  //         ),
  //       ),
  //     ),
  //   );
  //   if (handlePreviewResult(v)) {
  //     // print(v);
  //     Navigator.pop(context, v);
  //     return;
  //   }
  //   // isPushed = false;
  //   compareAndRemoveEntities(result.previewSelectedList);
  // }

  void _pickAsset(PickType type, {List<AssetPathEntity> pathList}) async {
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
      maxSelected: 9,
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
      pickType: type,
      photoPathList: pathList,
      pickedAssetList: imageDataList,
//      checkBoxSelectedColor: Colors.yellow,
    );

    if (imgList == null || imgList.isEmpty) return;
    imageDataList = imgList;
    assetProvider.current = AssetPathEntity();
    setState(() {});
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

  void _submit() async {
    List<String> imagePathes = [];
    List<AddFeedParamCellModel> uploadedIds = [];

    if (imageDataList.length > 0) {
      for (AssetEntity e in imageDataList) {
        File file = await e.file;
        imagePathes.add(file.absolute.path);
        await GetDataTool.uploadFile(file, (value) {
          UploadFileResultModel result = value;
          AddFeedParamCellModel param = AddFeedParamCellModel.fromJson(result.toJson());
          uploadedIds.add(param);
        });
      }
    }

    if (selectedGroupId == 0) {
      AddFeedParamModel param = AddFeedParamModel(
          contentTextEditingController.text);
      if (uploadedIds.length > 0) {
        param.images = uploadedIds;
      }
      GetDataTool.addFeed(param, (value) {
        Navigator.of(context).pop();
      });
    }else {
      String body = contentTextEditingController.text;
      String title = body;
      if (body.length > 20) title = body.substring(0,19);
      String summary = body;
      if (body.length > 120) summary = body.substring(0,119);

      AddPostParamModel param = AddPostParamModel(title, body, summary: summary);
//      param.syncFeed = 1;
      if (uploadedIds.length > 0) {
        param.images = uploadedIds;
      }
      GetDataTool.addPost(selectedGroupId, param, (value) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('发动态', style:Theme.of(context).textTheme.headline1),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                color: Colors.white,//CIRAppTheme.secondaryTitleTextColor,
                onPressed: _submit,
                child: Text('发布',
                  style: TextStyle(fontSize: 14)
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: CIRAppTheme.mainTitleTextColor)
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 200,
              child: TextField(
                style: Theme.of(context).textTheme.bodyText1,
                controller: contentTextEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: '记录此刻...',
                  contentPadding: EdgeInsets.all(10.0),
                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  border: InputBorder.none,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo) ,
                  onPressed: () => _pickAsset(PickType.onlyImage),
                ),
                IconButton(
                  icon: Icon(Icons.videocam),
                  onPressed: () => _pickAsset(PickType.onlyVideo),
                ),
                IconButton(
                  icon: Icon(Icons.album),
                  onPressed: () => _pickAsset(PickType.all),
                ),
              ],
            ),
            Expanded(
              child: buildGridView(),
            ),
          ],
        ),
      );
  }
}