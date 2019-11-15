import 'package:fluro/fluro.dart';
import 'package:flutter_wechat/routers/router_init.dart';

import 'setting/setting_page.dart';
import 'package:flutter_wechat/views/profile/about_us/about_us_page.dart';
import 'profile_page.dart';

class ProfileRouter implements IRouterProvider {
  /// 我root页
  static String profilePage = "/profile";

  /// 设置
  static String settingPage = "/profile/setting";

  /// 关于微信
  static String aboutUsPage = "/profile/about-us";

  /// 当前账号登陆
  static String currentprofilePage = "/profile/current-profile";

  /// 手机号登录
  static String phoneprofilePage = "/profile/phone-profile";

  /// 语言选择器
  static String languagePickerPage = "/profile/language-picker";

  @override
  void initRouter(Router router) {
    router.define(profilePage,
        handler: Handler(handlerFunc: (_, params) => ProfilePage()));
    router.define(settingPage,
        handler: Handler(handlerFunc: (_, params) => SettingPage()));
    router.define(aboutUsPage,
        handler: Handler(handlerFunc: (_, params) => AboutUsPage()));
    // router.define(otherLoginPage,
    //     handler: Handler(handlerFunc: (_, params) => OtherLoginPage()));
    // router.define(currentLoginPage,
    //     handler: Handler(handlerFunc: (_, params) => CurrentLoginPage()));
    // router.define(phoneLoginPage, handler: Handler(handlerFunc: (_, params) {
    //   final String phone = params['phone']?.first;
    //   final String zoneCode = params['zone_code']?.first;
    //   return PhoneLoginPage(
    //     phone: phone,
    //     zoneCode: zoneCode,
    //   );
    // }));
    // router.define(languagePickerPage,
    //     handler: Handler(handlerFunc: (_, params) {
    //   final String language = params['language']?.first;
    //   return LanguagePickerPage(value: language);
    // }));
  }
}
