import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flustars/flustars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'
    as FlutterScreenUtil;

// -[flutter_page_indicator](https://github.com/best-flutter/flutter_page_indicator)
// import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_wechat/components/photo_browser/photo.dart';
import 'package:flutter_wechat/components/photo_browser/mh_page_indicator.dart';

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
  // 当前索引页
  int _currentIndex;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    // 监听滚动
    widget.pageController.addListener(_onController);
    super.initState();
  }

  @override
  void didUpdateWidget(PhotoBrowser oldWidget) {
    if (widget.pageController != oldWidget.pageController) {
      oldWidget.pageController.removeListener(_onController);
      widget.pageController.addListener(_onController);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_onController);
    super.dispose();
  }

  // page view 滚动
  void _onController() {}

  // page_view 滚动一页
  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
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
            // 内容页
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.photos.length,
              loadingBuilder: (context, progress) => Center(
                child: Container(
                  width: FlutterScreenUtil.ScreenUtil().setWidth(30.0 * 3.0),
                  height: FlutterScreenUtil.ScreenUtil().setWidth(30.0 * 3.0),
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
            // 指示器
            Positioned(
              bottom: FlutterScreenUtil.ScreenUtil().setHeight(60.0) +
                  FlutterScreenUtil.ScreenUtil.bottomBarHeight,
              child: Offstage(
                offstage: widget.photos.length == 1,
                child: new PageIndicator(
                  layout: PageIndicatorLayout.SCALE,
                  size: FlutterScreenUtil.ScreenUtil().setWidth(30.0),
                  controller: widget.pageController,
                  space: FlutterScreenUtil.ScreenUtil().setWidth(15.0),
                  count: widget.photos.length,
                  initialPage: widget.initialIndex,
                ),
              ),
            ),

            // titile
            Positioned(
              top: FlutterScreenUtil.ScreenUtil.statusBarHeight,
              child: Offstage(
                offstage: false,
                child: Text(
                  widget.photos[_currentIndex].title ?? '',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: FlutterScreenUtil.ScreenUtil().setSp(16.0 * 3)),
                ),
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
