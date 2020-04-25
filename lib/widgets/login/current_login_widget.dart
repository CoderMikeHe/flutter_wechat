import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'
    as FlutterScreenUtil;

import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/routers/routers.dart';

import 'package:flutter_wechat/widgets/transition/slide_transition_x.dart';

import 'package:flutter_wechat/widgets/text_field/mh_text_field.dart';
import 'package:flutter_wechat/widgets/alert_dialog/mh_alert_dialog.dart';
import 'package:flutter_wechat/widgets/loading_dialog/loading_dialog.dart';

import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/utils/service/account_service.dart';

// 适配完毕
class CurrentLoginWidget extends StatefulWidget {
  CurrentLoginWidget({Key key}) : super(key: key);

  _CurrentLoginWidgetState createState() => _CurrentLoginWidgetState();
}

class _CurrentLoginWidgetState extends State<CurrentLoginWidget> {
  // 切换登陆方式
  bool _showPasswordWay = true;

  // 切换名称
  String get _changeLoginName => _showPasswordWay ? "用短信验证码登录" : "用微信密码登录";

  /// 登录按钮是否无效
  bool get _loginBtnDisabled {
    return _showPasswordWay
        ? _passwordController.text.isEmpty
        : _captchaController.text.isEmpty;
  }

  /// 账号信息
  String get _account {
    // 手机号
    final String phone =
        Util.formatMobile344(AccountService.sharedInstance.currentUser.phone);
    // 地区部编码
    final String zoneCode =
        Util.isEmptyString(AccountService.sharedInstance.currentUser.zoneCode)
            ? '86'
            : AccountService.sharedInstance.currentUser.zoneCode;
    // 格式化手机
    final formatPhone = '+' + zoneCode + ' ' + phone;
    // 切换 展示
    return _showPasswordWay
        ? AccountService.sharedInstance.currentUser.qq
        : formatPhone;
  }

  // loginBtnTitle
  String get _loginBtnTitle => "登录";

  /// 验证码名称
  String _captchaTitle = "获取验证码";

  /// 验证码是否不可点击
  bool _captchaBtnDisabled = false;

  /// 定时器
  Timer _timer;

  /// 是否输错过密码
  bool _inputPasswordError = false;

  /// 是否输错过验证码
  bool _inputCaptchaError = false;

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
    // 设置默认展示
    _showPasswordWay =
        AccountService.sharedInstance.currentUser.channel != "Mobile Phone";
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
  void _login() {
    // 按钮不可点击，则过滤
    if (_loginBtnDisabled) return;
    if (_showPasswordWay) {
      // 密码登陆 验证账号+密码
      // 1、验证phone 是不是正确 2、密码8-16位且不含中文
      if (_passwordController.text.length < 8 ||
          _passwordController.text.length > 16 ||
          RegexUtil.isZh(_passwordController.text)) {
        if (_inputPasswordError) {
          MHAlertDialog.alert(
            context,
            title: Text('密码错误，找回或重置密码'),
            actions: <Widget>[
              MHDialogAction(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MHDialogAction(
                child: Text('找回密码'),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
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
        }
        _inputPasswordError = true;
        return;
      }
    } else {
      // 验证码登录 纯6位数字
      if (_captchaController.text.length != 6 ||
          !Util.pureDigitCharacters(_captchaController.text)) {
        final content = !_inputCaptchaError ? "你输入的是一个无效的手机号码" : "";
        final title = !_inputCaptchaError ? "手机号码错误" : "验证码超时，请重新获取验证码";
        MHAlertDialog.alert(
          context,
          title: Text(title),
          content: content.length == 0 ? null : Text(content),
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
        _inputCaptchaError = true;
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
      // 当前用户
      final User user = AccountService.sharedInstance.currentUser;
      // 配置用户信息
      user.channel = _showPasswordWay ? "QQ" : "Mobile Phone";
      // 如果没有 zoneCode 则默认是中国
      user.zoneCode = Util.isEmptyString(user.zoneCode) ? '86' : user.zoneCode;

      // 用户登陆
      AccountService.sharedInstance
          .loginUser(user, rawLogin: _showPasswordWay ? user.qq : user.phone);

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
    if (!RegexUtil.isMobileExact('13265873384')) {
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
    final content = "我们将发送验证码短信到这个号码：" + _account;
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

  /// 获取验正码
  void _fetchCaptcha() {
    setState(() {
      // 获取验证��
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
      padding: EdgeInsets.only(
          top: FlutterScreenUtil.ScreenUtil().setHeight(149 * 3.0)),
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
    final double imageWH = FlutterScreenUtil.ScreenUtil().setWidth(66 * 3.0);
    return Container(
      padding: EdgeInsets.only(
          bottom: FlutterScreenUtil.ScreenUtil().setHeight(44 * 3.0)),
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl:
                'http://tva3.sinaimg.cn/crop.0.6.264.264.180/93276e1fjw8f5c6ob1pmpj207g07jaa5.jpg',
            placeholder: (context, url) {
              return Image.asset(
                Constant.assetsImagesDefault + 'DefaultProfileHead_66x66.png',
                width: imageWH,
                height: imageWH,
              );
            },
            errorWidget: (context, url, error) {
              print('头像报错 $error');
              return Image.asset(
                Constant.assetsImagesDefault + 'DefaultProfileHead_66x66.png',
                width: imageWH,
                height: imageWH,
              );
            },
            width: imageWH,
            height: imageWH,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: FlutterScreenUtil.ScreenUtil().setWidth(5 * 3.0)),
            child: Text(
              _account,
              style: TextStyle(
                color: Style.pTextColor,
                fontSize: FlutterScreenUtil.ScreenUtil().setSp(18 * 3.0),
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
      padding: EdgeInsets.symmetric(
          horizontal: FlutterScreenUtil.ScreenUtil().setWidth(20 * 3.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: FlutterScreenUtil.ScreenUtil().setWidth(105 * 3.0),
            child: Text(
              '密码',
              style: TextStyle(
                color: Style.pTextColor,
                fontSize: FlutterScreenUtil.ScreenUtil().setSp(17.0 * 3.0),
              ),
            ),
          ),
          Expanded(
            child: MHTextField(
              controller: _passwordController,
              hintText: '请填写密码',
              maxLength: 16,
              obscureText: true,
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
      padding: EdgeInsets.symmetric(
          horizontal: FlutterScreenUtil.ScreenUtil().setWidth(20 * 3.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: FlutterScreenUtil.ScreenUtil().setWidth(105 * 3.0),
            child: Text(
              '验证码',
              style: TextStyle(
                color: Style.pTextColor,
                fontSize: FlutterScreenUtil.ScreenUtil().setSp(17.0 * 3.0),
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
            padding: EdgeInsets.symmetric(
                horizontal: FlutterScreenUtil.ScreenUtil().setWidth(5 * 3.0),
                vertical: FlutterScreenUtil.ScreenUtil().setHeight(2 * 3.0)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(
                  FlutterScreenUtil.ScreenUtil().setWidth(3 * 3.0))),
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
                  fontSize: FlutterScreenUtil.ScreenUtil().setSp(13 * 3.0),
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
      padding: EdgeInsets.only(
        left: FlutterScreenUtil.ScreenUtil().setWidth(20 * 3.0),
        top: FlutterScreenUtil.ScreenUtil().setHeight(16 * 3.0),
        right: FlutterScreenUtil.ScreenUtil().setWidth(20 * 3.0),
      ),
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
            fontSize: FlutterScreenUtil.ScreenUtil().setSp(16 * 3.0),
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
      padding: EdgeInsets.only(
        left: FlutterScreenUtil.ScreenUtil().setWidth(20 * 3.0),
        top: FlutterScreenUtil.ScreenUtil().setHeight(63 * 3.0),
        right: FlutterScreenUtil.ScreenUtil().setWidth(20 * 3.0),
        bottom: 0,
      ),
      child: Opacity(
        opacity: _loginBtnDisabled ? 0.5 : 1,
        child: Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(
                    vertical: FlutterScreenUtil.ScreenUtil().setWidth(11 * 3.0),
                    horizontal:
                        FlutterScreenUtil.ScreenUtil().setHeight(24 * 3.0)),
                color: Style.pTintColor,
                highlightColor:
                    _loginBtnDisabled ? Colors.transparent : Style.sTintColor,
                splashColor: _loginBtnDisabled ? Colors.transparent : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                      FlutterScreenUtil.ScreenUtil().setWidth(4 * 3.0))),
                ),
                onPressed: _login,
                child: Text(
                  _loginBtnTitle,
                  style: TextStyle(
                    fontSize: FlutterScreenUtil.ScreenUtil().setSp(17.0 * 3.0),
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
      indent: FlutterScreenUtil.ScreenUtil().setWidth(20 * 3.0),
      endIndent: FlutterScreenUtil.ScreenUtil().setWidth(20 * 3.0),
      color: Style.pDividerColor,
    );
  }
}
