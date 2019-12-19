import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/views/login/login_router.dart';
import 'package:flutter_wechat/views/profile/profile_rourer.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';
import 'package:flutter_wechat/components/action_sheet/action_sheet.dart';
import 'package:flutter_wechat/widgets/loading_dialog/loading_dialog.dart';

import 'package:flutter_wechat/utils/service/account_service.dart';

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
      ),
    );
  }

  /// 配置数据
  List<CommonGroup> _configData(BuildContext context) {
    // group0
    // 账号与安全
    final accountSecurity = CommonItem(
      title: '账号与安全',
      onTap: (_) {
        NavigatorUtils.push(context, ProfileRouter.accountSecurityPage);
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
        NavigatorUtils.push(context, ProfileRouter.messageNotifyPage);
      },
    );
    // 隐私
    final privates = CommonItem(
      title: "隐私",
      onTap: (_) {
        NavigatorUtils.push(context, ProfileRouter.privatesPage);
      },
    );
    // 通用
    final general = CommonItem(
      title: "通用",
      onTap: (_) {
        NavigatorUtils.push(context, ProfileRouter.generalPage);
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
    final aboutUs = CommonItem(
      title: "关于微信",
      subtitle: "微信7.0.3",
      onTap: (_) {
        NavigatorUtils.push(context, ProfileRouter.aboutUsPage);
      },
    );
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
    final logout = CommonCenterItem(
        title: "退出登录",
        onTap: (_) {
          _showActionSheet(context);
        });
    final group5 = CommonGroup(
      items: [logout],
    );

    // 添加数据源
    return [group0, group1, group2, group3, group4, group5];
  }

  /// 构建actionsheet
  void _showActionSheet(BuildContext context) {
    ActionSheet.show(
      context,
      title: Text('退出后不会删除任何历史数据，下次登录依然可以使用本账号'),
      actions: <Widget>[
        ActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();

            /// 配置数据
            final loading = LoadingDialog(
                buildContext: context, loadingMessage: '正在加载中...');

            /// show loading
            loading.show();
            // 延时1s执行返回,模拟网络加载
            Future.delayed(
              Duration(seconds: 1),
              () async {
                // hide loading
                loading.hide();

                // 退出登录
                AccountService.sharedInstance.logoutUser();

                // 回到当前登陆
                NavigatorUtils.push(context, LoginRouter.currentLoginPage,
                    clearStack: true, transition: TransitionType.fadeIn);
              },
            );
          },
          isDestructiveAction: true,
          child: Text('退出登录'),
        ),
      ],
      cancelButton: ActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('取消'),
      ),
    );
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
