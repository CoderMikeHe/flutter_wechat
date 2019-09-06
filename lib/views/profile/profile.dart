import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

import 'package:flutter_wechat/views/profile/setting/setting_page.dart';
import 'package:flutter_wechat/views/profile/user_info/user_info_page.dart';

import 'package:flutter_wechat/views/profile/widgets/profile_header.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      icon: Constant.assetsImages + "WeChatPay_25x25.png",
    );
    final group0 = CommonGroup(
      items: [pay],
      headerHeight: 8.0,
    );

    // group1
    // 收藏
    final collect = CommonItem(
        title: "收藏", icon: Constant.assetsImages + "MoreMyFavorites_25x25.png");
    // 相册
    final album = CommonItem(
        title: "相册", icon: Constant.assetsImages + "MoreMyAlbum_25x25.png");
    // 卡包
    final card = CommonItem(
        title: "卡包",
        icon: Constant.assetsImages + "MyCardPackageIcon_25x25.png");
    // 表情
    final expression = CommonItem(
        title: "表情",
        icon: Constant.assetsImages + "MoreExpressionShops_25x25.png");

    final group1 = CommonGroup(
      items: [collect, album, card, expression],
    );

    // group2
    // 设置
    final setting = CommonItem(
      title: "设置",
      icon: Constant.assetsImages + "MoreSetting_25x25.png",
      onTap: (_) {
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (_) {
            return SettingPage();
          },
        ));
      },
    );
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
    return Container(
      child: Scaffold(
        body: CustomScrollView(
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
