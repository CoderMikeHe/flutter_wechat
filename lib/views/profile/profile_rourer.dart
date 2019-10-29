import 'package:fluro/fluro.dart';
import 'package:flutter_wechat/routers/router_init.dart';

import 'setting/setting_page.dart';
// import 'language_picker/language_picker_page.dart';
// import 'current_login/current_login_page.dart';
// import 'phone_login/phone_login_page.dart';
// import 'register/register_page.dart';
import 'profile_page.dart';

class ProfileRouter implements IRouterProvider {
  /// 我root页
  static String profilePage = "/profile";

  /// 注册
  static String settingPage = "/profile/setting";

  /// 其他账号登陆
  static String otherprofilePage = "/profile/other-profile";

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
