import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

import 'package:flutter_wechat/views/profile/general/general_page.dart';

class ChatRecordBackupPage extends StatelessWidget {
  const ChatRecordBackupPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('聊天记录备份与迁移'),
        ),
        body: Container(
          child: _buildChildWidget(context),
        ));
  }

  /// 配置数据
  List<CommonGroup> _configData(BuildContext context) {
    // group0
    // 迁移聊天记录到另一台设备
    final moveToDevice = CommonItem(
      title: '迁移聊天记录到另一台设备',
    );
    // 备份聊天记录到电脑
    final backupToPC = CommonItem(
      title: "备份聊天记录到电脑",
    );
    final group0 = CommonGroup(
      items: [moveToDevice, backupToPC],
    );

    // 添加数据源
    return [group0];
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
