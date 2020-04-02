import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
// -[flutter_page_indicator](https://github.com/best-flutter/flutter_page_indicator)
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

import 'package:flutter_wechat/components/photo_browser/photo.dart';

class PhotoBrowser extends StatefulWidget {
  PhotoBrowser({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.photos,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<Photo> photos;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _PhotoBrowserState();
  }
}

class _PhotoBrowserState extends State<PhotoBrowser> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 设置成黑色
      backgroundColor: Colors.black,
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.photos.length,
              loadingBuilder: (context, progress) => Center(
                child: Container(
                  width: 30.0,
                  height: 30.0,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black45,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                    value: progress == null
                        ? null
                        : progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes,
                  ),
                ),
              ),
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
              // gaplessPlayback: true,
              // reverse: true,
            ),
            Positioned(
              bottom: 20.0,
              child: new PageIndicator(
                layout: PageIndicatorLayout.SCALE,
                size: 10.0,
                controller: widget.pageController,
                space: 5.0,
                count: widget.photos.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final Photo item = widget.photos[index];
    // NetworkImage(item.url)
    return PhotoViewGalleryPageOptions(
      imageProvider: item.isLocal
          ? AssetImage(item.url)
          : CachedNetworkImageProvider(item.url),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.tag),
      onTapUp: (context, detail, value) {
        Navigator.pop(context);
      },
    );
  }
}
