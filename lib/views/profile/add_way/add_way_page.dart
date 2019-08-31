import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flutter_wechat/constant/constant.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/model/common/common_header.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

class AddWayPage extends StatelessWidget {
  const AddWayPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('添加我的方式'),
        ),
        body: Container(
          child: _buildChildWidget(context),
        ));
  }

  /// 配置数据
  List<CommonGroup> _configData(BuildContext context) {
    // group0
    // 手机号
    final phoneNumber = CommonSwitchItem(
      title: '手机号',
      cacheKey: CacheKey.findByPhoneNumberKey,
    );
    // 微信号
    final wechatId = CommonSwitchItem(
      title: "微信号",
      cacheKey: CacheKey.findByWechatIdKey,
    );
    // QQ号
    final qq = CommonSwitchItem(
      title: "QQ号",
      cacheKey: CacheKey.findByQQKey,
    );
    // 组头
    final CommonHeader header0 = CommonHeader(header: '可以通过以下方式找到我：');
    // 组尾
    final CommonFooter footer0 = CommonFooter(footer: '关闭后，其他用户将不不能通过上述信息找到你。');
    final group0 = CommonGroup(
      header: header0,
      items: [
        phoneNumber,
        wechatId,
        qq,
      ],
      footer: footer0,
    );

    // group1
    // 群聊
    final chatGroup =
        CommonSwitchItem(title: "群聊", cacheKey: CacheKey.addByChatGroupKey);
    // 我的二维码
    final myQrCode =
        CommonSwitchItem(title: "我的二维码", cacheKey: CacheKey.addByMyQrCodeKey);
    // 名片
    final visitingCard =
        CommonSwitchItem(title: "名片", cacheKey: CacheKey.addByVisitingCardKey);
    // 组头
    final CommonHeader header1 = CommonHeader(header: '可以通过以下方式添加我：');
    final group1 = CommonGroup(
      header: header1,
      items: [
        chatGroup,
        myQrCode,
        visitingCard,
      ],
    );

    // 添加数据源
    return [group0, group1];
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
