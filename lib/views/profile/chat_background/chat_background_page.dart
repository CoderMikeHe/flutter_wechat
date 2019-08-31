import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

import 'package:flutter_wechat/views/profile/general/general_page.dart';

class ChatBackgroundPage extends StatelessWidget {
  const ChatBackgroundPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('聊天背景'),
        ),
        body: Container(
          child: _buildChildWidget(context),
        ));
  }

  /// 配置数据
  List<CommonGroup> _configData(BuildContext context) {
    // group0
    // 选择背景图
    final chooseChatBg = CommonItem(
      title: '选择背景图',
    );
    final group0 = CommonGroup(
      items: [chooseChatBg],
    );

    // group1
    // 从手机相册选择
    final album = CommonItem(
      title: "从手机相册选择",
    );
    // 拍一张
    final camera = CommonItem(
      title: "拍一张",
    );
    final group1 = CommonGroup(
      items: [album, camera],
    );

    // group2
    // 将背景应用到所有聊天场景
    final useChoose = CommonCenterItem(title: "将背景应用到所有聊天场景");
    final group2 = CommonGroup(
      items: [useChoose],
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
