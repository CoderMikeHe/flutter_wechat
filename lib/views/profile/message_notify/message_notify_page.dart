import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flutter_wechat/constant/constant.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/model/common/common_header.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

class MessageNotifyPage extends StatelessWidget {
  const MessageNotifyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('新消息通知'),
        ),
        body: Container(
          child: _buildChildWidget(context),
        ));
  }

  /// 配置数据
  List<CommonGroup> _configData(BuildContext context) {
    // group0
    // 新消息通知
    final messageNotify = CommonSwitchItem(
      title: '新消息通知',
      cacheKey: CacheKey.messageNotifyKey,
    );
    // 语音和视频通话提醒
    final callReminder = CommonSwitchItem(
        title: "语音和视频通话提醒", cacheKey: CacheKey.callReminderKey);
    // 组头
    final CommonHeader header0 = CommonHeader(header: '微信未打开时');
    final group0 = CommonGroup(
      header: header0,
      items: [
        messageNotify,
        callReminder,
      ],
    );

    // group1
    // 通知显示消息详情
    final messageDetail = CommonSwitchItem(
        title: "通知显示消息详情", cacheKey: CacheKey.notifyMessageDetailKey);
    final group1 = CommonGroup(
      items: [messageDetail],
      footerHeight: 0.0,
    );

    // group2
    // 声音
    final notifyVoice =
        CommonSwitchItem(title: "声音", cacheKey: CacheKey.notifyVoiceKey);
    // 振动
    final notifyVibration =
        CommonSwitchItem(title: "振动", cacheKey: CacheKey.notifyVibrationKey);
    // 组头
    final CommonHeader header2 = CommonHeader(header: '微信打开时');
    final group2 = CommonGroup(
      header: header2,
      items: [
        notifyVoice,
        notifyVibration,
      ],
    );

    // 添加数据源
    return [group0, group1, group2];
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
