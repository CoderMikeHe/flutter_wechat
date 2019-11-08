import 'package:fluro/fluro.dart';
import 'package:flutter_wechat/routers/router_init.dart';

import 'contacts_page.dart';
import 'package:flutter_wechat/views/contacts/add_friend/add_friend_page.dart';
import 'package:flutter_wechat/views/contacts/contact_info/contact_info_page.dart';
import 'package:flutter_wechat/views/contacts/contact_more_info/contact_more_info_page.dart';
import 'package:flutter_wechat/views/contacts/contact_setting_info/contact_setting_info.dart';

class ContactsRouter implements IRouterProvider {
  /// 联系人 root页
  static String contactsPage = "/contacts";

  /// 添加好友
  static String addFriendPage = "/contacts/add-friend";

  /// 联系人信息
  static String contactInfoPage = "/contacts/contact-info";

  /// 联系人更多信息
  static String contactMoreInfoPage = "/contacts/contact-more-info";

  /// 联系人资料设置
  static String contactSettingInfoPage = "/contacts/contact-setting-info";

  @override
  void initRouter(Router router) {
    router.define(contactsPage,
        handler: Handler(handlerFunc: (_, params) => ContactsPage()));
    router.define(addFriendPage,
        handler: Handler(handlerFunc: (_, params) => AddFriendPage()));
    router.define(
      contactInfoPage,
      handler: Handler(handlerFunc: (_, params) {
        final String idstr = params['idstr']?.first;
        return ContactInfoPage(
          idstr: idstr,
        );
      }),
    );
    router.define(
      contactMoreInfoPage,
      handler: Handler(handlerFunc: (_, params) {
        final String idstr = params['idstr']?.first;
        return ContactMoreInfoPage(
          idstr: idstr,
        );
      }),
    );
    router.define(
      contactSettingInfoPage,
      handler: Handler(handlerFunc: (_, params) {
        final String idstr = params['idstr']?.first;
        return ContactSettingInfoPage(
          idstr: idstr,
        );
      }),
    );
  }
}
