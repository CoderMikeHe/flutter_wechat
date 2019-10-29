import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/widgets/transition/slide_transition_x.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/routers/routers.dart';

import 'package:flutter_wechat/widgets/login/login_title_widget.dart';
import 'package:flutter_wechat/widgets/text_field/mh_text_field.dart';
import 'package:flutter_wechat/widgets/alert_dialog/mh_alert_dialog.dart';
import 'package:flutter_wechat/widgets/loading_dialog/loading_dialog.dart';

import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/utils/service/account_service.dart';

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

  /// 验证码名称
  String _captchaTitle = "获取验证码";

  /// 验证码是否不可点击
  bool _captchaBtnDisabled = false;

  /// 定时器
  Timer _timer;

  /// _timerMaxCount 定时器最大时间, default is 60
  int _timerMaxCount = 60;

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
  void dispose() {
    super.dispose();
    // 关闭定时器
    _cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    return _buildChidWidgets();
  }

  /// -------------------- 事件 --------------------
  /// 登陆事件
  void _login() {
    // 按钮不可点击，则过滤
    if (_loginBtnDisabled) return;

    if (_showPasswordWay) {
      // 密码登陆 验证账号+密码
      // 1、验证phone 是不是正确 2、密码8-16位且不含中文
      if (!RegexUtil.isMobileExact(widget.phone) ||
          _passwordController.text.length < 8 ||
          _passwordController.text.length > 16 ||
          RegexUtil.isZh(_passwordController.text)) {
        MHAlertDialog.alert(
          context,
          title: Text('账号或密码错误，请重新填写'),
          actions: <Widget>[
            MHDialogAction(
              child: Text('确定'),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
        return;
      }
    } else {
      // 1、验证phone 是不是正确 2、验证码登录 纯6位数字
      if (!RegexUtil.isMobileExact(widget.phone) ||
          _captchaController.text.length != 6 ||
          !Util.pureDigitCharacters(_captchaController.text)) {
        MHAlertDialog.alert(
          context,
          title: Text('验证码超时，请重新获取验证码'),
          actions: <Widget>[
            MHDialogAction(
              child: Text('确定'),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
        return;
      }
    }

    /// 配置数据
    final loading = LoadingDialog(buildContext: context);

    /// show loading
    loading.show();
    // 延时1s执行返回,模拟网络加载
    Future.delayed(Duration(seconds: 1), () async {
      // hide loading
      loading.hide();
      // 获取用户信息
      final jsonStr =
          await rootBundle.loadString(Constant.mockData + 'user.json');
      var userJson = json.decode(jsonStr);
      final User user = User.fromJson(userJson);
      // 配置用户信息
      user.qq = "491273090";
      user.email = "491273090" + "@qq.com"; // PS：机智，拼接成QQ邮箱
      user.phone = widget.phone; // PS：瞎写的
      user.channel = "Mobile Phone";

      // 用户登陆
      AccountService.sharedInstance.loginUser(user, rawLogin: user.phone);

      // 登陆主界面 清掉堆栈
      NavigatorUtils.push(context, Routers.homePage,
          clearStack: true, transition: TransitionType.fadeIn);
    });
  }

  /// 获取验证码事件
  void _captchaAction() {
    // 不可点击，则负略点击事件
    if (_captchaBtnDisabled) return;

    // 1、判断电话号码是否正确
    if (!RegexUtil.isMobileExact(widget.phone)) {
      MHAlertDialog.alert(
        context,
        title: Text('手机号码错误'),
        content: Text('你输入的是一个无效的手机号码'),
        actions: <Widget>[
          MHDialogAction(
            child: Text('确定'),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
      return;
    }

    // 2、弹出有提示
    final content = "我们将发送验证码短信到这个号码：" + _phoneFormat;
    MHAlertDialog.alert(
      context,
      title: Text('确认手机号码'),
      content: Text(content),
      actions: <Widget>[
        MHDialogAction(
          child: Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        MHDialogAction(
          child: Text('确定'),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop();
            // 获取验证码
            _fetchCaptcha();
          },
        ),
      ],
    );
  }

  /// 获取验证码
  void _fetchCaptcha() {
    setState(() {
      // 获取验证码
      _captchaBtnDisabled = true;
      _captchaTitle = "发送中...";
    });

    // 延时1s执行返回
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _timerMaxCount = 60;
        _captchaTitle = "60s后重新发送";
      });

      // 开启一个定时器
      //设置 1 秒回调一次
      const period = const Duration(seconds: 1);
      _timer = Timer.periodic(period, _timerValueChanged);
    });
  }

  /// 定时器事件
  _timerValueChanged(Timer timer) {
    setState(() {
      _timerMaxCount--;
      if (_timerMaxCount == 0) {
        // 关掉定时器
        _cancelTimer();
        _captchaBtnDisabled = false;
        _captchaTitle = "获取验证码";
        return;
      }
      _captchaTitle = "$_timerMaxCount后重新发送";
    });
  }

  /// 取消定时器
  void _cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
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

  /// 构建标题+输��小部件
  Widget _buildTitleInputWidget() {
    return Container(
      width: double.maxFinite,
      color: Colors.white,
      child: _buildPhoneLoginWidget(),
    );
  }

  /// 构建手机号登录的Widgets
  Widget _buildPhoneLoginWidget() {
    // 动画组件 ��部件 必须加key
    var animatedSwitcher = AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        //执行缩放动���
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
              keyboardType: TextInputType.number,
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
              border: Border.all(
                  color: _captchaBtnDisabled
                      ? Color(0xFF999999)
                      : Color(0xFF353535)),
            ),
            child: InkWell(
              onTap: _captchaAction,
              child: Text(
                _captchaTitle,
                style: TextStyle(
                  color: _captchaBtnDisabled
                      ? Color(0xFF999999)
                      : Style.pTextColor,
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
