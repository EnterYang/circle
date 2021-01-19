import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/group/post_list_result_model.dart';
import 'package:circle/core/services/common_data_util.dart';
import 'package:circle/core/services/size_fit.dart';
import 'package:circle/ui/pages/feed/widgets/feed_list_item_image_module.dart';
import 'package:circle/ui/widgets/cir_cache_network_image_provider.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'package:circle/core/extension/int_extension.dart';

class PhotoGallery {
  PhotoGallery.show({@required BuildContext context,@required int initialIndex,@required List images }){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const ContinuousRectangleBorder(),
      builder: (BuildContext context) {
        return Container(
            color: Colors.white,
            child: PhotoViewGalleryPage(galleryItems: images, initialIndex: initialIndex, onTapUp: (){
              Navigator.of(context).pop();
            },)
        );
      },
    );
  }
}

class PhotoViewGalleryPage extends StatefulWidget {
  PhotoViewGalleryPage({Key key, @required this.galleryItems, this.initialIndex = 0, this.onTapUp}) : super(key: key);
  final List<dynamic> galleryItems;
  final int initialIndex;
  final VoidCallback onTapUp;

  @override
  _PhotoViewGalleryPageState createState() => _PhotoViewGalleryPageState();
}

class _PhotoViewGalleryPageState extends State<PhotoViewGalleryPage> {
  int pageViewActiveIndex;

  @override
  Widget build(BuildContext context) {
    if(pageViewActiveIndex == null) pageViewActiveIndex = widget.initialIndex;
    return Scaffold(
      body: Stack(
          children:<Widget>[
            Container(
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  var image = widget.galleryItems[index];
                  int fileId;
                  String size;
                  if(image is PostImageModel) {
                    fileId = image.fileId;
                    size = image.size;
                  }else if(image is ImageModel){
                    fileId = image.file;
                    size = image.size;
                  }
                  List<String> sizeStrings = size.split('x');
                  double imgWidth = double.parse(sizeStrings.first);
                  double imgHeight = double.parse(sizeStrings.last);
                  return PhotoViewGalleryPageOptions.customChild(
                      child: FeedListItemImageModule(fileId: fileId,),
                      childSize: Size(imgWidth, imgHeight),
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                      heroAttributes: PhotoViewHeroAttributes(tag: widget.galleryItems[index]),
                      onTapUp: (BuildContext context, TapUpDetails details, PhotoViewControllerValue controllerValue,){
                        widget.onTapUp();
                      }
                  );
                },
                itemCount: widget.galleryItems.length,
                loadingBuilder: (context, _progress) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: _progress == null
                          ? null
                          : _progress.cumulativeBytesLoaded /
                          _progress.expectedTotalBytes,
                    ),
                  ),
                ),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.white,
                ),
                pageController: PageController(initialPage: widget.initialIndex),
                onPageChanged: (currentIndex) {
                  pageViewActiveIndex = currentIndex;
                  this.setState(() {});
                },
              ),
            ),

            //图片页码指示器
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.galleryItems.length, (i) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: widget.galleryItems.length <= 1 ? 0.0 : 6.0,
                      width: widget.galleryItems.length <= 1 ? 0.0 : 6.0,
                      decoration: BoxDecoration(
                        color: pageViewActiveIndex == i
                            ? Colors.blueAccent
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList()
                ),
              ),
            ),
          ]
      ),
    );
  }
}
