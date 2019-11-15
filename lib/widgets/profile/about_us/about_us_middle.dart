import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';

class AboutUsMiddle extends StatelessWidget {
  /// 构造函数
  const AboutUsMiddle({Key key, this.onTap}) : super(key: key);

  /// 回调事见
  final void Function(String title) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildChildWidget(),
    );
  }

  /// 构建子部件
  Widget _buildChildWidget() {
    return Column(
      children: <Widget>[
        _buildItemWidget('去评分'),
        _buildItemWidget('功能介绍'),
        _buildItemWidget('投诉'),
        _buildItemWidget('版本更新'),
      ],
    );
  }

  /// 构建item 部件
  Widget _buildItemWidget(String title) {
    Widget middle = Padding(
      padding: EdgeInsets.only(right: Constant.pEdgeInset),
      child: Text(
        title,
        style: TextStyle(fontSize: 16.0, color: Style.pTextColor),
      ),
    );

    Widget trailing = Image.asset(
      Constant.assetsImagesArrow + 'tableview_arrow_8x13.png',
      width: 8.0,
      height: 13.0,
    );

    return MHListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 40.0),
      middle: middle,
      trailing: trailing,
      height: 50.0,
      dividerIndent: 40.0,
      dividerEndIndent: 40.0,
      onTap: () {
        if (onTap != null && onTap is Function) {
          onTap(title);
        }
      },
    );
  }
}
