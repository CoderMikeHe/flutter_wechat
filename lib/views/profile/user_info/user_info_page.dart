import 'package:flutter/material.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/views/profile/profile_rourer.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('个人信息'),
        ),
        body: Container(
          child: _buildChildWidget(context),
        ));
  }

  /// 配置数据
  List<CommonGroup> _configData(BuildContext context) {
    // group0
    // 头像
    final avatar = CommonImageItem(
      title: '头像',
      imageUrl:
          'http://tva3.sinaimg.cn/crop.0.6.264.264.180/93276e1fjw8f5c6ob1pmpj207g07jaa5.jpg',
      width: 66.0,
      height: 66.0,
      isNetwork: true,
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
    );

    // 名字
    final screenName = CommonItem(
      title: '名字',
      subtitle: 'Mike-乱港三千-Mr_元先森',
    );
    // 微信号
    final wechatId = CommonTextItem(
      title: '微信号',
      subtitle: 'codermikehe',
    );
    // 我的二维码
    final qrCode = CommonImageItem(
      title: '我的二维码',
      imageUrl: Constant.assetsImagesProfile + 'setting_myQR_36x36.png',
      width: 18.0,
      height: 18.0,
    );
    // 更多
    final moreInfo = CommonItem(
      title: '更多',
      onTap: (_) {
        NavigatorUtils.push(context, ProfileRouter.moreInfoPage);
      },
    );
    final group0 = CommonGroup(
      items: [avatar, screenName, wechatId, qrCode, moreInfo],
    );

    // group1
    // 我的地址
    final myAddress = CommonItem(
      title: "我的地址",
    );
    final group1 = CommonGroup(
      items: [myAddress],
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
