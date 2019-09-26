import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/widgets/transition/slide_transition_x.dart';

import 'package:flutter_wechat/widgets/text_field/mh_text_field.dart';

class CurrentLoginWidget extends StatefulWidget {
  CurrentLoginWidget({Key key}) : super(key: key);

  _CurrentLoginWidgetState createState() => _CurrentLoginWidgetState();
}

class _CurrentLoginWidgetState extends State<CurrentLoginWidget> {
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
      padding: EdgeInsets.only(top: 149.0),
      width: double.maxFinite,
      child: Column(
        children: <Widget>[
          _buildAccountInfoWidget(),
          _buildTitleInputWidget(),
          _buildChangeButtonWidget(),
          _buildLoginButtonWidget(),
        ],
      ),
    );
  }

  /// 构建 Avatar + 账号信息
  Widget _buildAccountInfoWidget() {
    return Container(
      padding: EdgeInsets.only(bottom: 44.0),
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl:
                'http://tva3.sinaimg.cn/crop.0.6.264.264.180/93276e1fjw8f5c6ob1pmpj207g07jaa5.jpg',
            placeholder: (context, url) {
              print('placeholder');
              return Image.asset(
                'assets/images/DefaultProfileHead_66x66.png',
                width: 66.0,
                height: 66.0,
              );
            },
            errorWidget: (context, url, error) {
              print('头像报错 $error');
              return Image.asset(
                'assets/images/DefaultProfileHead_66x66.png',
                width: 66.0,
                height: 66.0,
              );
            },
            width: 66.0,
            height: 66.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              '491273090',
              style: TextStyle(
                color: Style.pTextColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
          animatedSwitcher,
          _buildDivider(),
        ],
      ),
      width: double.maxFinite,
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
              maxLength: 16,
              obscureText: true,
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
              maxLength: 6,
              clearButtonMode: MHTextFieldWidgetMode.never,
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
      padding: EdgeInsets.only(left: 20.0, top: 16.0, right: 20.0),
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

  /// ��建登陆按钮部件
  Widget _buildLoginButtonWidget() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 63.0, right: 20.0, bottom: 0),
      child: Opacity(
        opacity: 1,
        child: Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 24.0),
                color: Style.pTintColor,
                highlightColor: Style.sTintColor,
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
