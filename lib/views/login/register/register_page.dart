import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/widgets/bar_button/bar_button.dart';
import 'package:flutter_wechat/widgets/login/register_widget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: _buildChidWidgets(context),
      ),
    );
  }

  /// -------------------- UI --------------------
  // 构建整体部件
  Widget _buildChidWidgets(BuildContext context) {
    // 头部
    Widget header = _buildHeaderWidget(context);
    // body
    Widget body = _buildBodyWidget(context);

    // 为了保证有种穿透 导航栏的错觉，这里使用 Stack
    return Stack(
      children: <Widget>[
        body,
        Positioned(
          child: header,
        )
      ],
    );
  }

  /// 构建头部小部件
  Widget _buildHeaderWidget(BuildContext context) {
    return Container(
      color: Colors.white38,
      padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
      alignment: Alignment.bottomLeft,
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      width: double.maxFinite,
      child: BarButton(
        '取消',
        textColor: Style.pTintColor,
        highlightTextColor: Style.pTintColor.withOpacity(0.5),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  /// 构建身体内容
  Widget _buildBodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
          top: kToolbarHeight + MediaQuery.of(context).padding.top),
      children: <Widget>[
        RegisterWidget(),
      ],
    );
  }
}
