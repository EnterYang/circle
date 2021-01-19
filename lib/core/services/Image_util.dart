import 'package:circle/core/extension/navigator_extension.dart';
import 'package:circle/ui/pages/chat/camera_page.dart';
import 'package:circle/ui/widgets/more_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
typedef OnCallBack = Future<void> Function(Object);
typedef OnCallBackWithType = Future<void> Function(int, Object);

class ImageUtil {
  /*
  * 从相机取图片
  */
  static Future getCameraImage() async {
    return await ImagePicker().getImage(source: ImageSource.camera);
  }

  /*
  * 从相册取图片
  */
  static Future<PickedFile> getGalleryImage() async {
    return await ImagePicker().getImage(source: ImageSource.gallery);
  }

  /*
  * 从相册取图片
  */
  static Future getGalleryAll() async {
    return await ImagePicker().getImage(source: ImageSource.gallery);
  }

  /*
  * 选择相机相册
  */
  static Future showPhotoChosen(BuildContext context, {OnCallBack onCallBack}) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text("拍照"),
                onTap: () async {
                  Navigator.pop(context);
                  ImageUtil.getCameraImage().then((image) {
                    if (onCallBack != null) {
                      onCallBack(image);
                    }
                  });
                },
              ),
              MoreWidgets.buildDivider(height: 0),
              new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text("相册"),
                onTap: () async {
                  Navigator.pop(context);
                  ImageUtil.getGalleryImage().then((image) {
                    if (onCallBack != null) {
                      onCallBack(image);
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  /*
  * 选择拍照片、拍视频
  */
  static Future showCameraChosen(BuildContext context, {OnCallBackWithType onCallBack}) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text("拍照片"),
                onTap: () async {
                  Navigator.pop(context);
                  ImageUtil.getCameraImage().then((image) {
                    if (onCallBack != null) {
                      onCallBack(1, image);
                    }
                  });
                },
              ),
              MoreWidgets.buildDivider(height: 0),
              new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text("拍视频"),
                onTap: () async {
                  Navigator.pop(context);
                  NavigatorExt.pushToPage(context, CameraPage());

//                  InteractNative.goNativeWithValue(
//                      InteractNative.methodNames['shootVideo'], null)
//                      .then((success) {
//                    if (success != null && success is Map) {
//                      if (onCallBack != null) {
//                        onCallBack(2, success);
//                      }
//                    } else {
//                      DialogUtil.buildToast(success.toString());
//                    }
//                  });
                },
              ),
            ],
          );
        });
  }
}
