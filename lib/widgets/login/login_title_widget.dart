import 'package:flutter/material.dart';
import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 适配完毕
class LoginTitleWidget extends StatelessWidget {
  const LoginTitleWidget({Key key, this.title}) : super(key: key);

  /// title
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20.0 * 3.0), 0,
          ScreenUtil().setWidth(20.0 * 3.0), ScreenUtil().setHeight(42.0)),
      child: Row(
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Style.pTextColor,
              fontSize: ScreenUtil().setSp(24.0 * 3),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
