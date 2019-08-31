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
      icon: Constant.assetsImages + "ff_IconShowAlbum_25x25.png",
      cacheKey: CacheKey.momentsKey,
    );
    // 扫一扫
    final qrCode = CommonSwitchItem(
        title: "扫一扫",
        icon: Constant.assetsImages + "ff_IconQRCode_25x25.png",
        cacheKey: CacheKey.qrCodeKey);
    // 摇一摇
    final shake = CommonSwitchItem(
        title: "摇一摇",
        icon: Constant.assetsImages + "ff_IconShake_25x25.png",
        cacheKey: CacheKey.shakeKey);
    // 看一看
    final look = CommonSwitchItem(
        title: "看一看",
        icon: Constant.assetsImages + "ff_IconBrowse1_25x25.png",
        cacheKey: CacheKey.lookKey);
    // 搜一搜
    final search = CommonSwitchItem(
        title: "搜一搜",
        icon: Constant.assetsImages + "ff_IconSearch1_25x25.png",
        cacheKey: CacheKey.searchKey);
    // 附近的人
    final locationService = CommonSwitchItem(
        title: "附近的人",
        icon: Constant.assetsImages + "ff_IconLocationService_25x25.png",
        cacheKey: CacheKey.locationServiceKey);
    // 漂流瓶
    final bottle = CommonSwitchItem(
        title: "漂流瓶",
        icon: Constant.assetsImages + "ff_IconBottle_25x25.png",
        cacheKey: CacheKey.bottleKey);
    // 购物
    final shopping = CommonSwitchItem(
        title: "购物",
        icon: Constant.assetsImages + "CreditCard_ShoppingBag_25x25.png",
        cacheKey: CacheKey.shoppingKey);
    // 游戏
    final game = CommonSwitchItem(
        title: "游戏",
        icon: Constant.assetsImages + "MoreGame_25x25.png",
        cacheKey: CacheKey.gameKey);
    // 小程序
    final moreApps = CommonSwitchItem(
        title: "小程序",
        icon: Constant.assetsImages + "MoreWeApp_25x25.png",
        cacheKey: CacheKey.moreAppsKey);

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
        moreApps
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
