import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';
import 'package:flutter_wechat/model/user/user.dart';

// 适配完毕
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
      color: Colors.white,
      child: _buildChildWidget(),
    );
  }

  /// 构建子部件
  Widget _buildChildWidget() {
    // CMH TODO: 增加 标签和电话的罗
    Widget middle = Padding(
      padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(Constant.pEdgeInset * 3)),
      child: Text(
        '备注和标签',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(48.0), color: Style.pTextColor),
      ),
    );

    Widget trailing = Image.asset(
      Constant.assetsImagesArrow + 'tableview_arrow_8x13.png',
      width: ScreenUtil().setWidth(24.0),
      height: ScreenUtil().setHeight(39.0),
    );

    return MHListTile(
      contentPadding:
          EdgeInsets.all(ScreenUtil().setWidth(Constant.pEdgeInset * 3.0)),
      middle: middle,
      trailing: trailing,
      dividerIndent: ScreenUtil().setWidth(Constant.pEdgeInset * 3),
    );
  }
}
