import 'package:fluro/fluro.dart';
import 'package:flutter_wechat/routers/router_init.dart';

import 'other_login/other_login_page.dart';
import 'language_picker/language_picker_page.dart';
import 'current_login/current_login_page.dart';
import 'phone_login/phone_login_page.dart';
import 'register/register_page.dart';
import 'login_page.dart';

class LoginRouter implements IRouterProvider {
  /// 登陆root页
  static String loginPage = "/login";

  /// 注册
  static String registerPage = "/login/register";

  /// 其他账号登陆
  static String otherLoginPage = "/login/other-login";

  /// 当前账号登陆
  static String currentLoginPage = "/login/current-login";

  /// 手机号登录
  static String phoneLoginPage = "/login/phone-login";

  /// 语言选择器
  static String languagePickerPage = "/login/language-picker";

  @override
  void initRouter(Router router) {
    router.define(loginPage,
        handler: Handler(handlerFunc: (_, params) => LoginPage()));
    router.define(registerPage,
        handler: Handler(handlerFunc: (_, params) => RegisterPage()));
    router.define(otherLoginPage,
        handler: Handler(handlerFunc: (_, params) => OtherLoginPage()));
    router.define(currentLoginPage,
        handler: Handler(handlerFunc: (_, params) => CurrentLoginPage()));
    router.define(phoneLoginPage, handler: Handler(handlerFunc: (_, params) {
      final String phone = params['phone']?.first;
      final String zoneCode = params['zone_code']?.first;
      return PhoneLoginPage(
        phone: phone,
        zoneCode: zoneCode,
      );
    }));
    router.define(languagePickerPage,
        handler: Handler(handlerFunc: (_, params) {
      final String language = params['language']?.first;
      return LanguagePickerPage(value: language);
    }));
  }
}
