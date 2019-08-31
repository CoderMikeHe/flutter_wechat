import 'package:flutter/material.dart';
import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/widgets/bar_button/bar_button.dart';

class BindingMailboxPage extends StatefulWidget {
  BindingMailboxPage({Key key}) : super(key: key);
  @override
  _BindingMailboxPageState createState() => _BindingMailboxPageState();
}

class _BindingMailboxPageState extends State<BindingMailboxPage> {
  String _errorText;

  /// 控制输入
  final TextEditingController _controller = TextEditingController(text: '');

  /// 控制键盘聚焦
  final FocusNode _focusNode = FocusNode();

  /// 完成按钮的有效性
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("邮箱地址"),
        // leading : 最大宽度为56.0
        leading: Container(
          padding: EdgeInsets.only(left: 16.0),
          alignment: Alignment.centerLeft,
          child: BarButton(
            '取消',
            textColor: Style.pTextColor,
            highlightTextColor: Style.sTextColor,
            onTap: () {
              // 键盘掉下
              _focusNode.unfocus();
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 16.0),
            alignment: Alignment.centerRight,
            child: BarButton(
              '完成',
              textColor: Colors.white,
              highlightTextColor: Colors.white.withOpacity(0.5),
              disabledTextColor: Colors.white.withOpacity(0.3),
              color: Style.pTintColor,
              highlightColor: Style.sTintColor,
              disabledColor: Style.sTintColor.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              enabled: _enabled,
              onTap: () {
                // TODO: 后面完成
                // 键盘掉下
                _focusNode.unfocus();
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 8.0),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: false,
              onSubmitted: (String text) {
                print('submit $text');
                setState(() {
                  if (!isEmail(text)) {
                    _errorText = 'Error: This is not an email';
                  } else {
                    _errorText = null;
                  }
                });
              },
              decoration: InputDecoration(
                hintText: "请输入邮箱地址",
                // 去掉底部分割线
                border: InputBorder.none,
              ),
              // 光标颜色
              cursorColor: Style.pTintColor,
              //内容改变的回调
              onChanged: (text) {
                print('change $text');
                setState(() {
                  _enabled = text.isNotEmpty;
                });
              },
              //按回车时调用
              onEditingComplete: () {
                // 键盘掉下
                _focusNode.unfocus();
              },
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Style.pDividerColor, width: 0.5),
                top: BorderSide(color: Style.pDividerColor, width: 0.5),
              ),
            ),
          ),
          Text(
            '你可以用验证过的邮箱来找回微信密码',
            style: TextStyle(color: Style.mTextColor, fontSize: 14.0),
          ),
        ],
      )),
    );
  }

  _getErrorText() {
    return _errorText;
  }

  bool isEmail(String em) {
    String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(emailRegexp);

    return regExp.hasMatch(em);
  }
}
