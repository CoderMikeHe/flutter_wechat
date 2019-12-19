import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flutter_wechat/constant/constant.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/model/common/common_header.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

class DiscoverManagerPage extends StatelessWidget {
  const DiscoverManagerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('发现页管理'),
        ),
        body: Container(
          child: _buildChildWidget(context),
        ));
  }

  /// 配置数据
  List<CommonGroup> _configData(BuildContext context) {
    // group0
    // 朋友圈
    final moments = CommonSwitchItem(
      title: '朋友圈',
      icon:
          Constant.assetsImagesDiscover + "icons_outlined_colorful_moment.svg",
      cacheKey: CacheKey.momentsKey,
    );
    // 扫一扫
    final qrCode = CommonSwitchItem(
      title: "扫一扫",
      icon: Constant.assetsImagesDiscover + "icons_outlined_scan.svg",
      cacheKey: CacheKey.qrCodeKey,
    );
    qrCode.iconColor = Color(0xFF3d83e6);

    // 摇一摇
    final shake = CommonSwitchItem(
      title: "摇一摇",
      icon: Constant.assetsImagesDiscover + "icons_outlined_shake.svg",
      cacheKey: CacheKey.shakeKey,
    );
    shake.iconColor = Color(0xFF3d83e6);

    // 看一看
    final look = CommonSwitchItem(
      title: "看一看",
      icon: Constant.assetsImagesDiscover + "icons_outlined_news.svg",
      cacheKey: CacheKey.lookKey,
    );
    look.iconColor = Color(0xFFF6C543);
    // 搜一搜
    final search = CommonSwitchItem(
      title: "搜一搜",
      icon: Constant.assetsImagesDiscover + "ff_IconSearch1_25x25.png",
      cacheKey: CacheKey.searchKey,
    );
    // 附近的人
    final locationService = CommonSwitchItem(
      title: "附近的人",
      icon: Constant.assetsImagesDiscover + "icons_outlined_nearby.svg",
      cacheKey: CacheKey.locationServiceKey,
    );
    locationService.iconColor = Color(0xFF3d83e6);
    // 漂流瓶
    final bottle = CommonSwitchItem(
      title: "漂流瓶",
      icon: Constant.assetsImagesDiscover + "icons_outlined_bottle.svg",
      cacheKey: CacheKey.bottleKey,
    );
    bottle.iconColor = Color(0xFF3d83e6);
    // 购物
    final shopping = CommonSwitchItem(
      title: "购物",
      icon: Constant.assetsImagesDiscover + "icons_outlined_shop.svg",
      cacheKey: CacheKey.shoppingKey,
    );
    shopping.iconColor = Color(0xFFE75E58);
    // 游戏
    final game = CommonSwitchItem(
      title: "游戏",
      icon: Constant.assetsImagesDiscover + "icons_outlined_colorful_game.svg",
      cacheKey: CacheKey.gameKey,
    );
    // 小程序
    final moreApps = CommonSwitchItem(
      title: "小程序",
      icon: Constant.assetsImagesDiscover + "icons_outlined_miniprogram.svg",
      cacheKey: CacheKey.moreAppsKey,
    );
    moreApps.iconColor = Color(0xFF6467e8);

    // 组头
    final CommonHeader header = CommonHeader(header: '打开/关闭发现页的入口');
    final CommonFooter footer =
        CommonFooter(footer: '关闭后，仅隐藏“发现”中该功能的入库，不会清空任何历史数据');

    final group0 = CommonGroup(
      header: header,
      items: [
        moments,
        qrCode,
        shake,
        look,
        search,
        locationService,
        bottle,
        shopping,
        game,
        moreApps,
      ],
      footer: footer,
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
