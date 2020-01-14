import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_wechat/constant/constant.dart';

class Applet extends StatefulWidget {
  Applet({Key key, this.offset, this.dragging}) : super(key: key);
// 偏移量 >= 0
  final double offset;

  // 是否是用户拖拽状态
  final bool dragging;
  _AppletState createState() => _AppletState();
}

class _AppletState extends State<Applet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          // navigation bar
          _buildNavigationBarWidget(),
          Expanded(
            child: _buildContentWidget(),
          ),
        ],
      ),
    );
  }

  // 导航栏
  Widget _buildNavigationBarWidget() {
    return Container(
      color: Colors.red,
      height: ScreenUtil.statusBarHeight + ScreenUtil().setHeight(44.0 * 3),
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        '小程序',
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 内容页面
  Widget _buildContentWidget() {
    return ListView(
      children: <Widget>[
        // 搜索框
        // 最近使用
        // 小程序
      ],
    );
  }

  /// 构建searchbar
  Widget _buildSearchBarWidget() {}

  //
}
