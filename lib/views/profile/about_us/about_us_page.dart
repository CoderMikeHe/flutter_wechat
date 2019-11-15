import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_wechat/widgets/profile/about_us/about_us_header.dart';
import 'package:flutter_wechat/widgets/profile/about_us/about_us_middle.dart';
import 'package:flutter_wechat/widgets/profile/about_us/about_us_footer.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        child: _buildChildWidget(context),
      ),
    );
  }

  /// 构建子部件
  Widget _buildChildWidget(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildHeaderWidget(),
        _buildMiddleWidget(),
        _buildFooterWidget(),
      ],
    );
  }

  /// 构建 header 部件
  Widget _buildHeaderWidget() {
    return Container(
      child: AboutUsHeader(),
      padding: EdgeInsets.symmetric(horizontal: 40.0),
    );
  }

  /// 构建 Middle 部件
  Widget _buildMiddleWidget() {
    return AboutUsMiddle(
      onTap: (title) {},
    );
  }

  /// 构建 Footer 部件
  Widget _buildFooterWidget() {
    final double height = ScreenUtil.screenHeightDp -
        218.5 -
        4 * 50 -
        kToolbarHeight -
        ScreenUtil.statusBarHeight;
    return AboutUsFooter(
      height: height,
    );
  }
}
