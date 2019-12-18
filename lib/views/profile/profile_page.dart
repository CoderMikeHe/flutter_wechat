import 'package:flutter/material.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/views/profile/profile_rourer.dart';

import 'package:flutter_wechat/constant/constant.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

import 'package:flutter_wechat/views/profile/user_info/user_info_page.dart';

import 'package:flutter_wechat/views/profile/widgets/profile_header.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /// 数据源
  List<CommonGroup> dataSource = [];

  @override
  void initState() {
    super.initState();
    // 配置数据源
    _configData();
  }

  /// 配置数据
  _configData() {
    // group0
    // 支付
    final pay = CommonItem(
      title: '支付',
      icon: Constant.assetsImagesProfile + "icons_outlined_wechatpay.svg",
    );

    final group0 = CommonGroup(
      items: [pay],
      headerHeight: 8.0,
    );

    // group1
    // 收藏
    final collect = CommonItem(
      title: "收藏",
      icon: Constant.assetsImagesProfile +
          "icons_outlined_colorful_favorites.svg",
    );
    // 相册
    final album = CommonItem(
      title: "相册",
      icon: Constant.assetsImagesProfile + "icons_outlined_album.svg",
    );
    album.iconColor = Color(0xFF3d83e6);
    // 卡包
    final card = CommonItem(
      title: "卡包",
      icon: Constant.assetsImagesProfile + "icons_outlined_colorful_cards.svg",
    );
    // 表情
    final expression = CommonItem(
      title: "表情",
      icon: Constant.assetsImagesProfile + "icons_outlined_sticker.svg",
    );
    expression.iconColor = Color(0xFFEDA150);

    final group1 = CommonGroup(
      items: [collect, album, card, expression],
    );

    // group2
    // 设置
    final setting = CommonItem(
      title: "设置",
      icon: Constant.assetsImagesProfile + "icons_outlined_setting.svg",
      onTap: (_) {
        NavigatorUtils.push(context, ProfileRouter.settingPage);
      },
    );
    setting.iconColor = Color(0xFF3d83e6);

    final group2 = CommonGroup(
      items: [setting],
    );
    // 添加数据源
    dataSource = [group0, group1, group2];
  }

  /// 列表数据
  Widget _buildListItem(BuildContext context, int index) {
    return CommonGroupWidget(
      group: dataSource[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            // 头部
            ProfileHeader(
              onTapTitle: () {
                print('点击昵称');
              },
              onTapContent: () {
                print('除了点击名称');
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (_) {
                    return UserInfoPage();
                  },
                ));
              },
            ),
            // 列表
            SliverList(
              delegate: SliverChildBuilderDelegate(_buildListItem,
                  childCount: dataSource.length),
            ),
          ],
        ),
      ),
    );
  }
}
