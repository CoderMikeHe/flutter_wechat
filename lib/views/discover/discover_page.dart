import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new _DiscoverPageState();
  }
}

class _DiscoverPageState extends State<DiscoverPage> {
  // 数据源
  List<CommonGroup> dataSource = [];

  @override
  void initState() {
    super.initState();

    // 配置数据源
    _configData();
  }

  // 配置数据
  _configData() {
    // group0
    // 朋友圈
    final moments = CommonItem(
      title: '朋友圈',
      icon:
          Constant.assetsImagesDiscover + "icons_outlined_colorful_moment.svg",
    );
    final group0 = CommonGroup(
      items: [moments],
    );

    // group1
    // 扫一扫
    final qrCode = CommonItem(
        title: "扫一扫",
        icon: Constant.assetsImagesDiscover + "icons_outlined_scan.svg");
    qrCode.iconColor = Color(0xFF3d83e6);
    // 摇一摇
    final shake = CommonItem(
        title: "摇一摇",
        icon: Constant.assetsImagesDiscover + "icons_outlined_shake.svg");
    shake.iconColor = Color(0xFF3d83e6);

    final group1 = CommonGroup(
      items: [qrCode, shake],
    );

    // group2
    // 看一看
    final look = CommonItem(
        title: "看一看",
        icon: Constant.assetsImagesDiscover + "icons_outlined_news.svg");
    look.iconColor = Color(0xFFF6C543);
    // 搜一搜
    final search = CommonItem(
        title: "搜一搜", icon: Constant.assetsImages + "ff_IconSearch1_25x25.png");
    final group2 = CommonGroup(
      items: [look, search],
    );

    // group3
    // 附近的人
    final locationService = CommonItem(
        title: "附近的人",
        icon: Constant.assetsImagesDiscover + "icons_outlined_nearby.svg");
    locationService.iconColor = Color(0xFF3d83e6);
    // 漂流瓶
    final bottle = CommonItem(
        title: "漂流瓶", icon: Constant.assetsImages + "ff_IconBottle_25x25.png");
    final group3 = CommonGroup(
      items: [locationService, bottle],
    );

    // group4
    // 购物
    final shopping = CommonItem(
      title: "购物",
      icon: Constant.assetsImagesDiscover + "icons_outlined_shop.svg",
    );
    shopping.iconColor = Color(0xFFE75E58);

    // 游戏
    final game = CommonItem(
        title: "游戏",
        icon:
            Constant.assetsImagesDiscover + "icons_outlined_colorful_game.svg");
    final group4 = CommonGroup(
      items: [shopping, game],
    );

    // group5
    // 小程序
    final moreApps = CommonItem(
      title: "小程序",
      icon: Constant.assetsImagesDiscover + "icons_outlined_miniprogram.svg",
    );
    moreApps.iconColor = Color(0xFF6467e8);
    final group5 = CommonGroup(
      items: [moreApps],
    );

    // 添加数据源
    dataSource = [group0, group1, group2, group3, group4, group5];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发现'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: dataSource.length,
          itemBuilder: (BuildContext context, int index) {
            return CommonGroupWidget(
              group: dataSource[index],
            );
          },
        ),
      ),
    );
  }
}
