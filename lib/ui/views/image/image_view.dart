import 'package:marvel/core/models/comic.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  final String heroTitle;
  final int? imageIndex;
  final List<Image>? imageList;
  final String? heroTag;
  const ImageView({
    super.key,
    this.imageIndex,
    this.imageList,
    this.heroTitle = "img",
    this.heroTag,
  });
  @override
  ImageViewState createState() => ImageViewState();
}

class ImageViewState extends State<ImageView> {
  PageController? pageController;
  int? currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex ?? 0);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      backgroundDecoration:
          BoxDecoration(color: Theme.of(context).primaryColor),
      scrollPhysics: const BouncingScrollPhysics(),
      pageController: pageController,
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(
            '${widget.imageList?[index].path}.${widget.imageList?[index].extension}',
          ),
          minScale: PhotoViewComputedScale.contained,
          heroAttributes: PhotoViewHeroAttributes(
              tag: '${widget.heroTag}${widget.imageList?[index].path}'),
        );
      },
      onPageChanged: onPageChanged,
      itemCount: widget.imageList?.length,
      loadingBuilder: (context, _) => Material(
        color: Theme.of(context).primaryColor,
        child: const Center(
          child: SizedBox(
            width: 60.0,
            height: 60.0,
            child: SpinKitThreeBounce(
              color: Colors.red,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}
