import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';

import 'package:flutter_wechat/constant/constant.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/views/login/login_router.dart';
import 'package:flutter_wechat/routers/routers.dart';

import 'package:flutter_wechat/widgets/login/current_login_widget.dart';

import 'package:flutter_wechat/components/action_sheet/action_sheet.dart';

class CurrentLoginPage extends StatefulWidget {
  CurrentLoginPage({Key key}) : super(key: key);

  _CurrentLoginPageState createState() => _CurrentLoginPageState();
}

class _CurrentLoginPageState extends State<CurrentLoginPage> {
  /// 关闭按钮是否高亮
  bool _closeBtnHighlight = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      children: <Widget>[body, footer],
    );
  }

  /// 构建头部小部件
  Widget _buildHeaderWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
      alignment: Alignment.bottomLeft,
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
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
          CurrentLoginWidget(),
        ],
      ),
    );
  }

  /// 构建底部小部件
  Widget _buildFooterWidget() {
    return Container(
      color: Colors.transparent,
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
              '紧急冻结',
              style: TextStyle(
                color: Color(0xFF5b6a91),
                fontSize: 15.0,
              ),
            ),
            onTap: () {},
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
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
            onTap: () {
              _showActionSheet(context);
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
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
            NavigatorUtils.push(context, LoginRouter.otherLoginPage,
                transition: TransitionType.inFromBottom);
          },
          child: Text('登陆其他账号'),
        ),
        ActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('前往微信安全中心'),
        ),
        ActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            NavigatorUtils.push(context, LoginRouter.registerPage,
                transition: TransitionType.inFromBottom);
          },
          child: Text('注册'),
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
