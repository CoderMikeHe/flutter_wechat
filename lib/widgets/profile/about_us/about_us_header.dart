import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

class AboutUsHeader extends StatelessWidget {
  const AboutUsHeader({Key key}) : super(key: key);

  // 0.5 + 40 + 64 + 30 + 24 + 20 + 40 = 218.5px
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildChildWidget(),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Style.pDividerColor, width: 0.5)),
      ),
    );
  }

  /// 构建子部件
  Widget _buildChildWidget() {
    return Column(
      children: <Widget>[
        SizedBox(height: 40.0),
        Image.asset(
          Constant.assetsImagesAboutUs + 'About_WeChat_AppIcon_64x64.png',
          width: 64.0,
          height: 64.0,
        ),
        SizedBox(height: 30.0),
        Text(
          '微信 WeChat',
          style: TextStyle(
            color: Style.pTextColor,
            fontSize: 18.0,
            height: 24.0 / 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Version 7.0.8',
          style: TextStyle(
            color: Style.pTextColor,
            fontSize: 16.0,
            height: 20.0 / 16.0,
          ),
        ),
        SizedBox(height: 40.0),
      ],
    );
  }
}
