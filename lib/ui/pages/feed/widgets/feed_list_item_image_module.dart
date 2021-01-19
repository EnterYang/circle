import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/feed/get_file_result_model.dart';
import 'package:circle/core/model/group/post_list_result_model.dart';
import 'package:circle/core/services/common_data_util.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/model/feed/get_file_param_model.dart';
import 'package:circle/core/services/get_data_tool.dart';

class FeedListItemImageModule extends StatefulWidget {
  final ImageModel imgModel;
  final PostImageModel postImageModel;
  final int fileId;
  FeedListItemImageModule({Key key, this.imgModel, this.fileId, this.postImageModel}) : super(key: key);

  @override
  _FeedListItemImageModuleState createState() => _FeedListItemImageModuleState();
}

class _FeedListItemImageModuleState extends State<FeedListItemImageModule> with AutomaticKeepAliveClientMixin {
  String imgUrl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
       child: imgUrl == null ? Container() :
       CachedNetworkImage(
         imageUrl: imgUrl,
         imageBuilder: (context, imageProvider) => Container(
           decoration: BoxDecoration(
             image: DecorationImage(
                 image: imageProvider,
                 fit: BoxFit.cover,
             ),
           ),
         ),
         progressIndicatorBuilder: (context, url, downloadProgress) =>
             Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
         errorWidget: (context, url, error) => IconButton(icon: Icon(Icons.error), onPressed: (){
           _loadData();
         }),
       ),
//      Image.network(imgUrl,fit: BoxFit.cover,),
    );
  }

  _loadData() async {
    int fileId;
    if(widget.fileId != null){
      fileId = widget.fileId;
    } else if(widget.postImageModel != null){
      fileId = widget.postImageModel.fileId;
    } else{
      fileId = widget.imgModel.file;
    }

    CommonDataUtil dataUtil = CommonDataUtil.getInstance();
    imgUrl = await dataUtil.getFileUrlWithFileId(fileId);
    this.setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}