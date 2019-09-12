import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';

import 'package:flutter_wechat/widgets/login/other_login_widget.dart';

class OtherLoginPage extends StatefulWidget {
  OtherLoginPage({Key key}) : super(key: key);

  _OtherLoginPageState createState() => _OtherLoginPageState();
}

class _OtherLoginPageState extends State<OtherLoginPage> {
  /// 关闭按钮是否高亮
  bool _closeBtnHighlight = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _buildChidWidgets(),
      ),
    );
  }

  // 构建整体部件
  Widget _buildChidWidgets() {
    // 头部
    Widget header = _buildHeaderWidget();
    // 身体
    Widget body = _buildBodyWidget();
    // 尾部
    Widget footer = _buildFooterWidget();
    // 列
    return Column(
      children: <Widget>[header, body, footer],
    );
  }

  /// 构建头部小部件
  Widget _buildHeaderWidget() {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
      alignment: Alignment.bottomLeft,
      height: 64.0,
      width: double.maxFinite,
      child: InkWell(
        child: Image.asset(
          Constant.assetsImages +
              (_closeBtnHighlight
                  ? 'wsactionsheet_close_normal_16x16.png'
                  : 'wsactionsheet_close_press_16x16.png'),
          width: 20.0,
          height: 20.0,
        ),
        onHighlightChanged: (highlight) {
          print(highlight);
          setState(() {
            _closeBtnHighlight = highlight;
          });
        },
        onTap: () {
          Navigator.of(context).pop();
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
      ),
    );
  }

  Widget _buildBodyWidget() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: <Widget>[
          OtherLoginWidget(),
        ],
      ),
    );
  }

  /// 构建底部小部件
  Widget _buildFooterWidget() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Text(
              '找回密码',
              style: TextStyle(
                color: Color(0xFF5b6a91),
                fontSize: 15.0,
              ),
            ),
            onTap: () {},
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            height: 12.0,
            width: 1.0,
            color: Color(0xFF5b6a91),
          ),
          SizedBox(
            width: 10.0,
          ),
          InkWell(
            child: Text(
              '更多选项',
              style: TextStyle(
                color: Color(0xFF5b6a91),
                fontSize: 15.0,
              ),
            ),
            onTap: () {},
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
