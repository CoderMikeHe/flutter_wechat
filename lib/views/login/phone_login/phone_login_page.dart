import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';

import 'package:flutter_wechat/widgets/login/phone_login_widget.dart';

import 'package:flutter_wechat/widgets/action_sheet/action_sheet.dart';

class PhoneLoginPage extends StatefulWidget {
  PhoneLoginPage({Key key, this.phone, this.zoneCode}) : super(key: key);

  /// 电话号码
  final String phone;

  /// 地区code
  final String zoneCode;

  _PhoneLoginPageState createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    print(height);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0, // 隐藏AppBar底部细线阴影
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _showActionSheet(context);
            },
            icon: Icon(Icons.more_horiz),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: _buildChidWidgets(),
      ),
    );
  }

  // 构建整体部件
  Widget _buildChidWidgets() {
    // 身体
    Widget body = _buildBodyWidget();
    // 列
    return Column(
      children: <Widget>[body],
    );
  }

  Widget _buildBodyWidget() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: <Widget>[
          PhoneLoginWidget(
            phone: widget.phone,
            zoneCode: widget.zoneCode,
          ),
        ],
      ),
    );
  }

  /// 构建actionsheet
  void _showActionSheet(BuildContext context) {
    ActionSheet.show(
      context,
      actions: <Widget>[
        ActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('找回密码'),
        ),
        ActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('前往微信安全中心'),
        ),
      ],
      cancelButton: ActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('取消'),
      ),
    );
  }
}
