import 'dart:convert';

import 'package:fluro/fluro.dart';

import 'package:flutter_wechat/components/photo_browser/photo.dart';
import 'package:flutter_wechat/routers/router_init.dart';

import 'photo_browser.dart';

class PhotoBrowserRouter implements IRouterProvider {
  /// 图片浏览器 root页
  static String photoBrowserPage = "/photo-browser";

  @override
  void initRouter(Router router) {
    router.define(
      photoBrowserPage,
      handler: Handler(handlerFunc: (_, params) {
        final String initialIndex = params['initialIndex']?.first;
        final String jsonStr = params['photos']?.first;
        final List jsons = json.decode(jsonStr);

        /// photos
        final List<Photo> photos = [];
        // // 遍历
        jsons.forEach((json) {
          final Photo m = Photo.fromJson(json);
          photos.add(m);
        });
        return PhotoBrowser(
          photos: photos,
          initialIndex: int.parse(initialIndex),
        );
      }),
    );
  }
}
