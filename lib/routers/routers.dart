import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wechat/components/photo_browser/photo_browser.dart';

// import 'package:flutter_wechat/account/account_router.dart';
// import 'package:flutter_wechat/goods/goods_router.dart';
// import 'package:flutter_wechat/routers/404.dart';
import 'package:flutter_wechat/views/login/login_router.dart';
import 'package:flutter_wechat/views/profile/profile_rourer.dart';
import 'package:flutter_wechat/views/contacts/contacts_router.dart';
import 'package:flutter_wechat/components/photo_browser/photo_browser_router.dart';
import 'package:flutter_wechat/views/discover/discover_router.dart';

import 'package:flutter_wechat/views/login/current_login/current_login_page.dart';
import 'package:flutter_wechat/routers/router_init.dart';
// import 'package:flutter_wechat/setting/setting_router.dart';

// import 'package:flutter_wechat/home/home_page.dart';
// import 'package:flutter_wechat/home/webview_page.dart';
// import 'package:flutter_wechat/shop/shop_router.dart';
// import 'package:flutter_wechat/statistics/statistics_router.dart';
// import 'package:flutter_wechat/store/store_router.dart';

import 'package:flutter_wechat/views/home/home_page.dart';
import 'package:flutter_wechat/views/login/login_page.dart';
import 'package:flutter_wechat/views/splash/splash_page.dart';

class Routers {
  static String root = "/";
  static String homePage = "/home-page";
  static String webViewPage = "/web-view";

  static List<IRouterProvider> _listRouter = [];

  static void configureRoutes(Router router) {
    /// 指定路由跳转错误返回页
    // router.notFoundHandler = Handler(
    //     handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    //   debugPrint("未找到目标页");
    //   return Homepage();
    // });
    // 闪屏页面
    router.define(root,
        handler: Handler(
            handlerFunc:
                (BuildContext context, Map<String, List<String>> params) =>
                    SplashPage()));
    // 主页面
    router.define(homePage,
        handler: Handler(
            handlerFunc:
                (BuildContext context, Map<String, List<String>> params) =>
                    HomePage()));

    // router.define(webViewPage, handler: Handler(handlerFunc: (_, params) {
    //   String title = params['title']?.first;
    //   String url = params['url']?.first;
    //   return WebViewPage(title: title, url: url);
    // }));

    _listRouter.clear();

    /// 各自路由由各自模块管理，统一在此添加初始化
    // _listRouter.add(ShopRouter());
    _listRouter.add(LoginRouter());
    _listRouter.add(ProfileRouter());
    _listRouter.add(ContactsRouter());
    _listRouter.add(PhotoBrowserRouter());
    _listRouter.add(DiscoverRouter());
    // _listRouter.add(AccountRouter());
    // _listRouter.add(SettingRouter());
    // _listRouter.add(StatisticsRouter());

    /// 初始化路由
    _listRouter.forEach((routerProvider) {
      routerProvider.initRouter(router);
    });
  }
}
