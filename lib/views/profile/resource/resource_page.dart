import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flutter_wechat/constant/constant.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/model/common/common_header.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

class ResourcePage extends StatelessWidget {
  const ResourcePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('照片、视频和文件'),
        ),
        body: Container(
          child: _buildChildWidget(context),
        ));
  }

  /// 配置数据
  List<CommonGroup> _configData(BuildContext context) {
    // group0
    // 自动下载
    final autoDownload = CommonSwitchItem(
      title: '自动下载',
      cacheKey: CacheKey.autoDownloadKey,
    );

    // 组头
    final CommonHeader header0 =
        CommonHeader(header: '在其他设备查看的照片、视频和文件在手机上自动下载');
    final group0 = CommonGroup(
      header: header0,
      items: [autoDownload],
      footerHeight: 0.0,
    );

    // group1
    // 照片
    final picture =
        CommonSwitchItem(title: "照片", cacheKey: CacheKey.resourcePictureKey);
    // 视频
    final video =
        CommonSwitchItem(title: "视频", cacheKey: CacheKey.resourceVideoKey);
    final group1 = CommonGroup(
      header: CommonHeader(header: '拍摄或编辑后的内容保存到系统相册'),
      items: [
        picture,
        video,
      ],
      footerHeight: 0.0,
    );

    // group2
    // 移动网络下视频自动播放
    final autoPlay = CommonSwitchItem(
        title: "移动网络下视频自动播放", cacheKey: CacheKey.videoAutoPlayKey);
    // 组头
    final CommonHeader header2 = CommonHeader(header: '开启后，朋友圈视频在移动网络下自动播放');
    final group2 = CommonGroup(
      header: header2,
      items: [autoPlay],
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
