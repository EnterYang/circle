import 'package:circle/core/services/size_fit.dart';
import 'package:circle/ui/shared/media_util.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class VideoMessageItem extends StatefulWidget {
  final Direction direction;
  final EMVideoMessageBody messageBody;

  const VideoMessageItem({Key key, this.direction, this.messageBody}) : super(key: key);

  @override
  _VideoMessageItemState createState() => _VideoMessageItemState();
}

class _VideoMessageItemState extends State<VideoMessageItem> {
  String videoImagePath;
  Widget imageWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setVideoImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CIRSizeFit.screenWidth * 0.8 * (widget.messageBody.getVoiceDuration()/60),
      padding: EdgeInsets.all(5.px),
      constraints: BoxConstraints(
          minWidth: 55.px
      ),
      child: Row(
        mainAxisAlignment: widget.direction == Direction.SEND ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if(imageWidget != null) return imageWidget;
    return Container();
  }

  void setVideoImage() async {
    bool videoFileExists = await File(widget.messageBody.localUrl).exists();

    print('resultFrameImage:---------$videoFileExists--');

    if(!videoFileExists) return;

    FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    String filePath = widget.messageBody.localUrl;
    String resultFrameImage = await _genTempFramePath();

    String cmd = '-i $filePath -f image2 -ss 00:00:00 -vframes 1 $resultFrameImage';
    await _flutterFFmpeg.executeAsync(cmd, (executionId, returnCode) {
      print('resultFrameImage:--returnCode---------$returnCode');
    });

    print('resultFrameImage:-----------' + resultFrameImage);

    var imgFile = File(resultFrameImage);
    var bytes = imgFile.readAsBytesSync();
    var sth = await decodeImageFromList(bytes);
    var height = sth.height.toDouble();
    var width = sth.width.toDouble();
    double ratio = width / height;
    double maxRatio = 3;
    double minRatio = 1 / 3;
    double maxWidth = 300.px;
    double maxHeight = 375.px;
    BoxFit fitType;
    if (ratio >= maxRatio) {
      fitType = BoxFit.fitHeight;
      double scale = height / maxHeight;
      height = height / scale;
      width = height * maxRatio / scale;
    } else if (ratio <= maxRatio && ratio >= 1) {
      fitType = BoxFit.fitWidth;
      double scale = width / maxWidth;
      height = height / scale;
      width = width / scale;
    } else if (ratio >= minRatio && ratio < 1) {
      fitType = BoxFit.fitHeight;
      double scale = height / maxWidth;
      height = height / scale;
      width = width / scale;
    } else {
      fitType = BoxFit.fitWidth;
      double scale = width / maxWidth;
      height = height / scale;
      width = width / scale;
    }

    imageWidget = Image.file(imgFile,width: width,height: height,fit: fitType);

    this.setState(() { });
  }
  Future<String> _genTempFramePath() async {
    var folder = await getApplicationDocumentsDirectory();
    String tempImgFolder = "${folder.path}/tempVideoFrames/";
    if (! await Directory(tempImgFolder).exists()) {
    await Directory(tempImgFolder).create(recursive: true);
    }
    String title = widget.messageBody.localUrl.split('/').last;
    String result=p.join(tempImgFolder,"$title.jpg");
    return result;
  }
}
