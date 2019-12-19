import 'package:fluro/fluro.dart';
import 'package:flutter_wechat/routers/router_init.dart';

import 'package:flutter_wechat/views/profile/setting/setting_page.dart';
import 'package:flutter_wechat/views/profile/about_us/about_us_page.dart';
import 'package:flutter_wechat/views/profile/account_security/account_security_page.dart';
import 'package:flutter_wechat/views/profile/general/general_page.dart';
import 'package:flutter_wechat/views/profile/message_notify/message_notify_page.dart';
import 'package:flutter_wechat/views/profile/privates/privates_page.dart';
import 'profile_page.dart';

class ProfileRouter implements IRouterProvider {
  /// 我root页
  static String profilePage = "/profile";

  /// 设置
  static String settingPage = "/profile/setting";

  /// 关于微信
  static String aboutUsPage = "/profile/about-us";

  /// 账号与安全
  static String accountSecurityPage = "/profile/account-security";

  /// 新消息通知
  static String messageNotifyPage = "/profile/message-notify";

  /// 隐私
  static String privatesPage = "/profile/privates";

  /// 通用
  static String generalPage = "/profile/general";

  @override
  void initRouter(Router router) {
    // 我root页
    router.define(
      profilePage,
      handler: Handler(handlerFunc: (_, params) => ProfilePage()),
    );
    // 设置
    router.define(
      settingPage,
      handler: Handler(handlerFunc: (_, params) => SettingPage()),
    );
    router.define(aboutUsPage,
        handler: Handler(handlerFunc: (_, params) => AboutUsPage()));
    router.define(accountSecurityPage,
        handler: Handler(handlerFunc: (_, params) => AccountSecurityPage()));
    router.define(messageNotifyPage,
        handler: Handler(handlerFunc: (_, params) => MessageNotifyPage()));
    router.define(privatesPage,
        handler: Handler(handlerFunc: (_, params) => PrivatesPage()));
    router.define(generalPage,
        handler: Handler(handlerFunc: (_, params) => GeneralPage()));
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
