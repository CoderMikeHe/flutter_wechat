import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
// -[flutter_page_indicator](https://github.com/best-flutter/flutter_page_indicator)
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'
    as FlutterScreenUtil;

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

  PageController p;

  final List<Widget> _children = [];

  bool _add = false;

  /// widget渲染监听。
  WidgetUtil widgetUtil = new WidgetUtil();

  @override
  void initState() {
    currentIndex = widget.initialIndex;

    // 监听滚动
    widget.pageController.addListener(_onController);
    p = PageController(initialPage: widget.initialIndex);
    super.initState();

    // 初始化
    // _initialize();
    // 方案一： 先算出 SearchCube 的宽度，再去计算其位置 left ，虽然能实现，但是初次显示时会跳动
    widgetUtil.asyncPrepare(context, true, (Rect rect) {
      // 一定要做此判断
      if (widget.pageController.hasClients) {
        print('hasClients ${widget.initialIndex},');
        print('xxxxxxxxxxx ${widget.pageController.page}');
        // widget.pageController.jumpTo(0.01);
        // setState(() {
        // widget.pageController.animateToPage(
        //   widget.initialIndex,
        //   duration: const Duration(milliseconds: 400),
        //   curve: Curves.easeInOut,
        // );
        // });
        setState(() {
          _add = true;
        });
      } else {
        print('hasClients ---------');
        // 递归
        // _initialize();
      }
    });
  }

  void _initialize() {
    // 延时1s执行返回,
    // Fixed Bug: 当 widget.initialIndex > 0 时，PageIndicator 初始化时，不会指向指定的initialIndex数，导致默认时为一直0 的Bug；一旦pageController滚动，就会回归正常initialIndex
    if (widget.initialIndex != 0) {
      // 当不为0时，延时一丢丢 然后跳到指定页
      // Future.delayed(Duration(seconds: 5), () async {
      //   // 一定要做此判断
      //   if (widget.pageController.hasClients) {
      //     print('hasClients ${widget.initialIndex}');
      //     // widget.pageController.jumpToPage(widget.initialIndex);
      //     // setState(() {
      //     // widget.pageController.animateToPage(
      //     //   widget.initialIndex,
      //     //   duration: const Duration(milliseconds: 400),
      //     //   curve: Curves.easeInOut,
      //     // );
      //     // });
      //   } else {
      //     print('hasClients ---------');
      //     // 递归
      //     _initialize();
      //   }
      // });

      // 一定要做此判断
      if (widget.pageController.hasClients) {
        print('hasClients ${widget.initialIndex}');
        // widget.pageController.jumpToPage(widget.initialIndex);
        // setState(() {
        // widget.pageController.animateToPage(
        //   widget.initialIndex,
        //   duration: const Duration(milliseconds: 400),
        //   curve: Curves.easeInOut,
        // );
        // });
      } else {
        print('hasClients ---------');
        // 递归
        _initialize();
      }
    }
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
  void _onController() {
    double page = widget.pageController.page ?? 0.0;
    final index = page.floor();

    print('index is $index');
  }

  // page_view 滚动一页
  void onPageChanged(int index) {
    print('object');
    // setState(() {
    //   currentIndex = index;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> childs = [];

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
              child: Offstage(
                // offstage: widget.photos.length == 1,
                offstage: false,
                child: _add
                    ? new PageIndicator(
                        layout: PageIndicatorLayout.SCALE,
                        size: 10.0,
                        controller: widget.pageController,
                        space: 5.0,
                        count: widget.photos.length,
                      )
                    : SizedBox(
                        width: 0,
                        height: 0,
                      ),
              ),
            ),
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
