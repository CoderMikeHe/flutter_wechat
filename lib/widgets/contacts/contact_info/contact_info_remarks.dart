import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';
import 'package:flutter_wechat/model/user/user.dart';

class ContactInfoRemarks extends StatelessWidget {
  const ContactInfoRemarks({
    Key key,
    @required this.user,
  }) : super(key: key);

  /// 用户信息
  final User user;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildChildWidget(),
    );
  }

  /// 构建子部件
  Widget _buildChildWidget() {
    // CMH TODO: 增加 标签和电话的罗
    Widget middle = Padding(
      padding: EdgeInsets.only(right: Constant.pEdgeInset),
      child: Text(
        '设置备注和标签',
        style: TextStyle(fontSize: 16.0, color: Style.pTextColor),
      ),
    );

    Widget trailing = Image.asset(
      Constant.assetsImagesArrow + 'tableview_arrow_8x13.png',
      width: 8.0,
      height: 13.0,
    );

    return MHListTile(
      contentPadding: EdgeInsets.all(Constant.pEdgeInset),
      middle: middle,
      trailing: trailing,
      dividerIndent: Constant.pEdgeInset,
    );
  }
}
