import 'package:fluro/fluro.dart';
import 'package:flutter_wechat/routers/router_init.dart';

import 'package:flutter_wechat/views/discover/moments/moments_page.dart';
import 'discover_page.dart';

class DiscoverRouter implements IRouterProvider {
  /// 发现root页
  static String discoverPage = "/discover";

  /// 朋友圈
  static String momentsPage = "/discover/moments";

  @override
  void initRouter(Router router) {
    router.define(discoverPage,
        handler: Handler(handlerFunc: (_, params) => DiscoverPage()));
    router.define(momentsPage,
        handler: Handler(handlerFunc: (_, params) => MomentsPage()));
  }
}
