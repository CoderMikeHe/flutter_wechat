import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'
    as FlutterScreenUtil;

import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'login_router.dart';

// 适配完毕
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
  void _login() {
    NavigatorUtils.push(context, LoginRouter.otherLoginPage,
        transition: TransitionType.inFromBottom);
  }

  // 跳转注册
  void _register() {
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
                        fontSize:
                            FlutterScreenUtil.ScreenUtil().setSp(17.0 * 3.0),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(
                          FlutterScreenUtil.ScreenUtil().setWidth(12.0))),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical:
                            FlutterScreenUtil.ScreenUtil().setHeight(30.0),
                        horizontal:
                            FlutterScreenUtil.ScreenUtil().setWidth(24.0 * 3)),
                    color: Colors.white,
                    highlightColor: Color(0xd9d9d9),
                    onPressed: _login,
                  ),
                ),
                SizedBox(
                  width: FlutterScreenUtil.ScreenUtil().setWidth(60.0),
                  height: FlutterScreenUtil.ScreenUtil().setWidth(60.0),
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text(
                      '注册',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            FlutterScreenUtil.ScreenUtil().setSp(17.0 * 3.0),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(
                          FlutterScreenUtil.ScreenUtil().setWidth(12.0))),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical:
                            FlutterScreenUtil.ScreenUtil().setHeight(30.0),
                        horizontal:
                            FlutterScreenUtil.ScreenUtil().setWidth(24.0 * 3)),
                    color: Style.pTintColor,
                    highlightColor: Style.sTintColor,
                    onPressed: _register,
                  ),
                ),
              ],
            ),
          ),
          left: FlutterScreenUtil.ScreenUtil().setWidth(60.0),
          bottom: FlutterScreenUtil.ScreenUtil().setHeight(60.0),
          right: FlutterScreenUtil.ScreenUtil().setWidth(60.0),
        ),
        Positioned(
          child: Container(
            child: InkWell(
              onTap: _skip2SettingLanguage,
              child: Text(
                _language,
                style: TextStyle(
                  fontSize: FlutterScreenUtil.ScreenUtil().setSp(12.0 * 3.0),
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          top: FlutterScreenUtil.ScreenUtil().setHeight(15.0) +
              FlutterScreenUtil.ScreenUtil.statusBarHeight,
          right: FlutterScreenUtil.ScreenUtil().setWidth(60.0),
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
