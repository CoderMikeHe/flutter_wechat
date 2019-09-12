import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/views/login/language_picker/language_picker_page.dart';
import 'package:flutter_wechat/views/login/current_login/current_login_page.dart';
import 'package:flutter_wechat/views/login/other_login/other_login_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 当前选中语言
  String _language = '简体中文';

  @override
  void initState() {
    super.initState();
  }

  // 跳转登陆
  _login() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (_) {
          return OtherLoginPage();
        },
      ),
    );
  }

  // 跳转注册
  _register() {}

  // 跳转设置语言
  void _skip2SettingLanguage() async {
    final String result = await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (_) {
          return LanguagePickerPage(
            value: _language,
          );
        },
      ),
    );
    if (null != result && _language != result) {
      setState(() {
        _language = result;
      });
    }
  }

  // 生成整体小部件
  Widget _buildChildWidget() {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text(
                      '登陆',
                      style: TextStyle(
                        color: Style.sTintColor,
                        fontSize: 17.0,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
                    color: Colors.white,
                    highlightColor: Color(0xd9d9d9),
                    onPressed: _login,
                  ),
                ),
                SizedBox(
                  width: 20.0,
                  height: 20.0,
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text(
                      '注册',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
                    color: Style.pTintColor,
                    highlightColor: Style.sTintColor,
                    onPressed: _register,
                  ),
                ),
              ],
            ),
          ),
          left: 20.0,
          bottom: 20.0,
          right: 20.0,
        ),
        Positioned(
          child: Container(
            child: InkWell(
              onTap: _skip2SettingLanguage,
              child: Text(
                _language,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          top: 20.0,
          right: 20.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _buildChildWidget(),
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Constant.assetsImages + 'LaunchImage.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
