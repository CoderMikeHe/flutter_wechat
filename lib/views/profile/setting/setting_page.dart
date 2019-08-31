import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

import 'package:flutter_wechat/views/profile/general/general_page.dart';
import 'package:flutter_wechat/views/profile/message_notify/message_notify_page.dart';
import 'package:flutter_wechat/views/profile/privates/privates_page.dart';
import 'package:flutter_wechat/views/profile/account_security/account_security_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('设置'),
        ),
        body: Container(
          child: _buildChildWidget(context),
        ));
  }

  /// 配置数据
  List<CommonGroup> _configData(BuildContext context) {
    // group0
    // 账号与安全
    final accountSecurity = CommonItem(
      title: '账号与安全',
      onTap: (_) {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (_) {
              return AccountSecurityPage();
            },
          ),
        );
      },
    );
    final group0 = CommonGroup(
      items: [accountSecurity],
    );

    // group1
    // 新消息通知
    final messageNotify = CommonItem(
        title: "新消息通知",
        onTap: (_) {
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (_) {
              return MessageNotifyPage();
            },
          ));
        });
    // 隐私
    final privates = CommonItem(
        title: "隐私",
        onTap: (_) {
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (_) {
              return PrivatesPage();
            },
          ));
        });
    // 通用
    final general = CommonItem(
      title: "通用",
      onTap: (_) {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (_) {
              return GeneralPage();
            },
          ),
        );
      },
    );
    final group1 = CommonGroup(
      items: [messageNotify, privates, general],
    );

    // group2
    // 帮助与反馈
    final help = CommonItem(
      title: "帮助与反馈",
    );
    // 关于微信
    final aboutUs = CommonItem(title: "关于微信", subtitle: "微信7.0.3");
    final group2 = CommonGroup(
      items: [help, aboutUs],
    );

    // group3
    // 插件
    final plugin = CommonPluginItem(
      title: "插件",
    );
    final group3 = CommonGroup(
      items: [plugin],
    );

    // group4
    // 切换账号
    final switchAccount = CommonCenterItem(title: "切换账号");
    final group4 = CommonGroup(
      items: [switchAccount],
    );

    // 退出登录
    final logout = CommonCenterItem(title: "退出登录");
    final group5 = CommonGroup(
      items: [logout],
    );

    // 添加数据源
    return [group0, group1, group2, group3, group4, group5];
  }

  /// 构建child
  Widget _buildChildWidget(BuildContext context) {
    // 获取数据
    final List<CommonGroup> dataSource = _configData(context);
    return ListView.builder(
      itemCount: dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        return CommonGroupWidget(
          group: dataSource[index],
        );
      },
    );
  }
}
