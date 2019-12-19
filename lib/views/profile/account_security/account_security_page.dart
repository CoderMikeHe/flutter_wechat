import 'package:flutter/material.dart';
import 'package:flutter_wechat/routers/fluro_navigator.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

import 'package:flutter_wechat/views/profile/profile_rourer.dart';

/// 账号与安全
class AccountSecurityPage extends StatefulWidget {
  AccountSecurityPage({Key key}) : super(key: key);

  _AccountSecurityPageState createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
  /// 数据源
  List<CommonGroup> _dataSource = [];

  @override
  void initState() {
    super.initState();

    // 配置数据源
    _configData();
  }

  /// 配置数据
  _configData() {
    // group0
    // 微信号
    final wechatId = CommonTextItem(title: '微信号', subtitle: 'luangangsanqian');
    // 手机号 PS：这里模拟绑定
    final binded = false;
    final phoneNumber = CommonSecurityPhoneItem(
        title: '手机号', subtitle: binded ? '18674640795' : '未绑定', binded: binded);
    final group0 = CommonGroup(
      items: [wechatId, phoneNumber],
    );

    // group1
    // 微信密码
    final password = CommonItem(
      title: "微信密码",
      subtitle: '已设置',
      onTap: (_) {},
    );
    // 声音锁
    final voiceLock = CommonItem(
      title: "声音锁",
      subtitle: '未设置',
    );
    final group1 = CommonGroup(
      items: [
        password,
        voiceLock,
      ],
    );

    // group2
    // 应急联系人
    final emergencyContact = CommonItem(
      title: "应急联系人",
    );
    // 登陆设备管理
    final deviceManage = CommonItem(
      title: "登陆设备管理",
    );
    // 更多安全设置
    final moreSecuritySetting = CommonItem(
      title: "更多安全设置",
      onTap: (_) {
        NavigatorUtils.push(context, ProfileRouter.moreSecuritySettingPage);
      },
    );
    final group2 = CommonGroup(
      items: [
        emergencyContact,
        deviceManage,
        moreSecuritySetting,
      ],
    );

    // group3
    // 帮朋友冻结微信
    final helpLockWechat = CommonItem(
      title: "帮朋友冻结微信",
    );
    // 微信安全中心
    final securityCenter = CommonItem(
      title: "微信安全中心",
    );
    final group3 = CommonGroup(
      footer: CommonFooter(footer: '如果遇到账号信息泄露、忘记密码、诈骗等账号安全问题，可前往微信安全中心。'),
      items: [
        helpLockWechat,
        securityCenter,
      ],
    );

    // 添加数据源
    _dataSource = [group0, group1, group2, group3];
  }

  // 构建 child 的小部件
  Widget _buildChildWidget(BuildContext context) {
    return Container(
        child: ListView.builder(
      itemCount: _dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        return CommonGroupWidget(
          group: _dataSource[index],
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('账号与安全'),
      ),
      body: Container(
        child: _buildChildWidget(context),
      ),
    );
  }
}
