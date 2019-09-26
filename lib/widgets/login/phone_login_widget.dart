import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/widgets/transition/slide_transition_x.dart';

import 'package:flutter_wechat/widgets/login/login_title_widget.dart';
import 'package:flutter_wechat/widgets/text_field/mh_text_field.dart';

import 'package:flutter_wechat/views/login/phone_login/phone_login_page.dart';

class PhoneLoginWidget extends StatefulWidget {
  PhoneLoginWidget({Key key, this.phone, this.zoneCode}) : super(key: key);

  /// 电话号码
  final String phone;

  /// 地区code
  final String zoneCode;

  _PhoneLoginWidgetState createState() => _PhoneLoginWidgetState();
}

class _PhoneLoginWidgetState extends State<PhoneLoginWidget> {
  // 电话格式化
  String get _phoneFormat {
    return "+" +
        (widget.zoneCode ?? '') +
        " " +
        (Util.formatMobile344(widget.phone));
  }

  // 登录按钮是否无效
  bool get _loginBtnDisabled {
    return _showPasswordWay
        ? _passwordController.text.isEmpty
        : _captchaController.text.isEmpty;
  }

  // 切换登陆方式
  bool _showPasswordWay = true;

  // 切换名称
  String get _changeLoginName => _showPasswordWay ? "用短信验证码登录" : "用密码登录";

  // loginBtnTitle
  String get _loginBtnTitle => "登录";

  // 屏幕宽
  double _screenWidth = 0;
  // 验证码名称
  String captchaTitle = "获取验证码";
  // 验证码是否不可点击
  bool captchaBtnDisabled = false;

  /// password控制输入
  final TextEditingController _passwordController =
      TextEditingController(text: '');

  /// 验证码控制输入
  final TextEditingController _captchaController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    return _buildChidWidgets();
  }

  /// -------------------- 事件 --------------------
  void _login() {
    if (_showPasswordWay) {
    } else {}
  }

  /// -------------------- UI --------------------

  /// 初始化子部件
  Widget _buildChidWidgets() {
    return Container(
      padding: EdgeInsets.only(top: 90.0),
      width: double.maxFinite,
      child: Column(
        children: <Widget>[
          _buildTitleInputWidget(),
          _buildChangeButtonWidget(),
          _buildLoginButtonWidget(),
        ],
      ),
    );
  }

  /// 构建标题+输入小部件
  Widget _buildTitleInputWidget() {
    return Container(
      width: double.maxFinite,
      color: Colors.white,
      child: _buildPhoneLoginWidget(),
    );
  }

  /// 构建手机号登录的Widgets
  Widget _buildPhoneLoginWidget() {
    // 动画组件 子部件 必须加key
    var animatedSwitcher = AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        //执行缩放动画
        return SlideTransitionX(
          child: child, position: animation,
          direction: AxisDirection.left, //右入左出
        );
      },
      child: _showPasswordWay
          ? _buildPasswordLoginWidget()
          : _buildCaptchaLoginWidget(),
    );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LoginTitleWidget(title: '手机号登录'),
          _buildPhoneWidget(),
          _buildDivider(),
          animatedSwitcher,
          _buildDivider(),
        ],
      ),
      width: double.maxFinite,
    );
  }

  /// 构建选择手机号的Widget
  Widget _buildPhoneWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 105.0,
            child: Text(
              '手机号',
              style: TextStyle(
                color: Style.pTextColor,
                fontSize: 17.0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _phoneFormat,
              style: TextStyle(
                color: Style.pTextColor,
                fontSize: 17.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建密码登陆小部件
  Widget _buildPasswordLoginWidget() {
    return Container(
      key: ValueKey('password'),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 105.0,
            child: Text(
              '密码',
              style: TextStyle(
                color: Style.pTextColor,
                fontSize: 17.0,
              ),
            ),
          ),
          Expanded(
            child: MHTextField(
              controller: _passwordController,
              hintText: '请填写密码',
              obscureText: true,
              maxLength: 16,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建验证码登陆小部件
  Widget _buildCaptchaLoginWidget() {
    return Container(
      key: ValueKey('captcha'),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 105.0,
            child: Text(
              '验证码',
              style: TextStyle(
                color: Style.pTextColor,
                fontSize: 17.0,
              ),
            ),
          ),
          Expanded(
            child: MHTextField(
              controller: _captchaController,
              hintText: '请输入验证码',
              clearButtonMode: MHTextFieldWidgetMode.never,
              maxLength: 6,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
              border: Border.all(color: Color(0xFF353535)),
            ),
            child: InkWell(
              onTap: () {},
              child: Text(
                '获取验证码',
                style: TextStyle(
                  color: Style.pTextColor,
                  fontSize: 13.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建切换按钮部件
  Widget _buildChangeButtonWidget() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 34.0, right: 20.0),
      width: double.maxFinite,
      child: InkWell(
        onTap: () {
          setState(() {
            _showPasswordWay = !_showPasswordWay;
          });
        },
        child: Text(
          _changeLoginName,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color(0xFF5b6a91),
            fontSize: 16.0,
          ),
        ),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
      ),
    );
  }

  /// 构建登陆按钮部件
  Widget _buildLoginButtonWidget() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 63.0, right: 20.0, bottom: 0),
      child: Opacity(
        opacity: _loginBtnDisabled ? 0.5 : 1,
        child: Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 24.0),
                color: Style.pTintColor,
                highlightColor:
                    _loginBtnDisabled ? Colors.transparent : Style.sTintColor,
                splashColor: _loginBtnDisabled ? Colors.transparent : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                onPressed: _login,
                child: Text(
                  _loginBtnTitle,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 构建分割线
  Widget _buildDivider() {
    return Divider(
      height: 0.5,
      indent: 20.0,
      endIndent: 20.0,
      color: Style.pDividerColor,
    );
  }
}
