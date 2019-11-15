import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart';

import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'login_router.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 当前选中语言
  String _language = '';

  @override
  void initState() {
    super.initState();
    // 缓存中获取 language
    _language = SpUtil.getString(CacheKey.appLanguageKey, defValue: '简体中文');
  }

  // 跳转登陆
  _login() {
    NavigatorUtils.push(context, LoginRouter.otherLoginPage,
        transition: TransitionType.inFromBottom);
  }

  // 跳转注册
  _register() {
    NavigatorUtils.push(context, LoginRouter.registerPage,
        transition: TransitionType.inFromBottom);
  }

  // 跳转设置语言
  void _skip2SettingLanguage() {
    // 跳转到语言language 选择器
    // https://blog.csdn.net/huchengzhiqiang/article/details/91415777
    // Fixed Bug: 中文参数需要调用 Uri.encodeComponent()
    NavigatorUtils.pushResult(
      context,
      '${LoginRouter.languagePickerPage}?language=${Uri.encodeComponent(_language)}',
      (result) {
        if (null != result && _language != result) {
          setState(() {
            _language = result;
            // 保存缓存
            SpUtil.putString(CacheKey.appLanguageKey, _language);
          });
        }
      },
      transition: TransitionType.inFromBottom,
    );
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
