import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;

import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';

import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/routers/routers.dart';

import 'package:flutter_wechat/components/action_sheet/action_sheet.dart';
import 'package:flutter_wechat/widgets/text_field/mh_text_field.dart';
import 'package:flutter_wechat/widgets/alert_dialog/mh_alert_dialog.dart';
import 'package:flutter_wechat/widgets/loading_dialog/loading_dialog.dart';

import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/utils/service/account_service.dart';

class RegisterWidget extends StatefulWidget {
  RegisterWidget({Key key}) : super(key: key);

  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget>
    with SingleTickerProviderStateMixin {
  /// 关闭按钮是否高亮
  bool _avatarBtnHighlight = false;

  /// 协议文字是否高亮
  bool _agreementHighlight = false;

  /// 是否选中了协议
  bool _checked = false;

  /// 是否需要抖动
  bool _shaked = false;

  /// 登录按钮是否无效
  bool get _registerBtnDisabled {
    return _nicknameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _phoneController.text.isEmpty;
  }

  /// 密码是否不可见
  bool _hidePassword = true;

  /// nickname控制输入
  final TextEditingController _nicknameController =
      TextEditingController(text: '');

  /// phone控制输入
  final TextEditingController _phoneController =
      TextEditingController(text: '');

  /// zone控制输入
  final TextEditingController _zoneController = TextEditingController(text: '');

  /// password控制输入
  final TextEditingController _passwordController =
      TextEditingController(text: '');

  //平移动画控制器
  AnimationController _mAnimationController;
  //提供一个曲线，使动画感觉更流畅
  CurvedAnimation _offsetCurvedAnimation;
  //平移动画
  Animation<double> _offsetAnim;
  //执行时间  毫秒
  int _milliseconds = 200;

  @override
  void initState() {
    super.initState();
    _zoneController.text = '86';

    _mAnimationController = AnimationController(
        duration: Duration(milliseconds: _milliseconds), vsync: this);
    _offsetCurvedAnimation =
        new CurvedAnimation(parent: _mAnimationController, curve: _MyCurve());
    _offsetAnim =
        new Tween(begin: -1.0, end: 1.0).animate(_offsetCurvedAnimation);
    // //添加监听
    // ..addListener((){
    //   // print('object');
    // })
    // // 状态监听
    // ..addStatusListener((status){
    //   // print("$status"); // 打印状态
    //   // if (status == AnimationStatus.completed) {
    //   //   _mAnimationController.reset(); // 动画结束时，反转从尾到头播放，结束的状态是 dismissed
    //   // }
    //   // else if (status == AnimationStatus.dismissed) {
    //   //   _mAnimationController.forward(); // 重新从头到尾播放
    //   // }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return _buildChidWidgets();
  }

  /// -------------------- 事件 --------------------
  /// 注册
  void _register() {
    // 没填写，则过滤
    if (_registerBtnDisabled) {
      return;
    }

    // 没有选中服务条框，则抖动提示
    if (!_checked) {
      _shaked = true;
      if (_mAnimationController.status == AnimationStatus.completed) {
        _mAnimationController.reset(); // 动画为为完成状态时  重置 否则不可以调用forward
      }
      _mAnimationController.forward(); // 执行动画
      return;
    }

    // 验证手机号是否正确
    if (!RegexUtil.isMobileExact(_phoneController.text)) {
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

    // 验证密码正确
    if (_passwordController.text.length < 8 ||
        _passwordController.text.length > 16 ||
        RegexUtil.isZh(_passwordController.text) ||
        Util.pureDigitCharacters(_passwordController.text)) {
      MHAlertDialog.alert(
        context,
        title: Text('密码必须是8-16位英文字母、数字、字符组合（不能是纯数字）'),
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
      user.phone = _phoneController.text; // PS：瞎写的
      user.channel = "Mobile Phone";
      user.screenName = _nicknameController.text;

      // 用户登陆
      AccountService.sharedInstance.loginUser(user, rawLogin: user.phone);

      // 登陆主界面 清掉堆栈
      NavigatorUtils.push(context, Routers.homePage,
          clearStack: true, transition: TransitionType.fadeIn);
    });
  }

  /// 构建actionsheet
  void _showActionSheet(BuildContext context) {
    ActionSheet.show(
      context,
      actions: <Widget>[
        ActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('拍照'),
        ),
        ActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('从手机相册选择'),
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

  /// -------------------- UI --------------------
  /// 初始化子部件
  Widget _buildChidWidgets() {
    return Container(
      padding: EdgeInsets.only(top: 28.0),
      width: double.maxFinite,
      child: Column(
        children: <Widget>[
          _buildHeaderWidget(),
          _buildBodyWidget(),
          _buildFooterWidget(),
        ],
      ),
    );
  }

  /// ---- 构建头部组件
  Widget _buildHeaderWidget() {
    return Container(
      width: double.maxFinite,
      color: Colors.white,
      child: _buildHeaderChildWidget(),
    );
  }

  /// 构建头部子部件
  Widget _buildHeaderChildWidget() {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            '用手机号注册',
            style: TextStyle(
              fontSize: 21.0,
              fontWeight: FontWeight.w500,
              color: Style.pTextColor,
            ),
          ),
        ),
        InkWell(
          child: Padding(
            padding: EdgeInsets.only(top: 46.0),
            child: Image.asset(
              Constant.assetsImagesLogin +
                  (_avatarBtnHighlight
                      ? 'SignUpWC_ChangeAvatar_Hl_80x80.png'
                      : 'SignUpWC_ChangeAvatar_80x80.png'),
              width: 64.0,
              height: 64.0,
            ),
          ),
          onHighlightChanged: (highlight) {
            setState(() {
              _avatarBtnHighlight = highlight;
            });
          },
          onTap: () {
            _showActionSheet(context);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
        ),
      ],
    );
  }

  /// ---- 构建身体部件
  Widget _buildBodyWidget() {
    return Container(
      padding: EdgeInsets.only(top: 30.0, left: 20.0),
      width: double.maxFinite,
      color: Colors.white,
      child: _buildBodyChildWidget(),
    );
  }

  /// 构建身体子部件
  Widget _buildBodyChildWidget() {
    return Container(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildNicknameOrPasswordWidget(_nicknameController, '昵称', '例如：陈晨'),
          _buildSelectZoneWidget(),
          _buildZoneAndPhoneInputWidget(),
          _buildNicknameOrPasswordWidget(_passwordController, '密码', '请设置密码',
              obscure: _hidePassword, password: true),
        ],
      ),
    );
  }

  /// 构建昵称/密码小部件
  Widget _buildNicknameOrPasswordWidget(
      TextEditingController controller, String title, String placeholder,
      {bool obscure = false, bool password = false}) {
    return Container(
      padding: EdgeInsets.only(
          top: 10.0, bottom: 10.0, right: password ? 10.0 : 20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Style.pDividerColor, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 105.0,
            child: Text(
              title,
              style: TextStyle(
                color: Style.pTextColor,
                fontSize: 17.0,
              ),
            ),
          ),
          Expanded(
            child: MHTextField(
              controller: controller,
              hintText: placeholder,
              obscureText: obscure,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Offstage(
            offstage: !password,
            child: InkWell(
              child: Image.asset(
                Constant.assetsImagesLogin +
                    (_hidePassword
                        ? 'CellHidePassword_icon_22x14.png'
                        : 'CellHidePassword_icon_HL_22x14.png'),
                width: 22.0,
                height: 14.0,
              ),
              onTap: () {
                setState(() {
                  _hidePassword = !_hidePassword;
                });
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建选择地区的Widget
  Widget _buildSelectZoneWidget() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Style.pDividerColor, width: 0.5),
        ),
      ),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 105.0,
              child: Text(
                '国家/地区',
                style: TextStyle(
                  color: Style.pTextColor,
                  fontSize: 17.0,
                ),
              ),
            ),
            Expanded(
              child: Text(
                '中国大陆',
                style: TextStyle(
                  color: Style.pTextColor,
                  fontSize: 17.0,
                ),
              ),
            ),
            Image.asset(
              Constant.assetsImagesArrow + 'tableview_arrow_8x13.png',
              width: 8.0,
              height: 13.0,
            )
          ],
        ),
      ),
    );
  }

  /// 构建地区部和手机 输入小部件
  Widget _buildZoneAndPhoneInputWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Style.pDividerColor, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: MHTextField(
                    controller: _zoneController,
                    prefixMode: MHTextFieldWidgetMode.always,
                    clearButtonMode: MHTextFieldWidgetMode.never,
                    maxLength: 4,
                    prefix: Text(
                      '+',
                      style: TextStyle(
                        color: Style.pTextColor,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 10.0,
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: .5, color: Style.pDividerColor),
              ),
            ),
            child: SizedBox(
              height: 24.0,
              width: 10.0,
            ),
          ),
          Expanded(
            child: MHTextField(
              controller: _phoneController,
              hintText: '请填写手机号码',
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          SizedBox(width: 20.0)
        ],
      ),
    );
  }

  /// ---- 构建尾部部件
  Widget _buildFooterWidget() {
    return Container(
      padding: EdgeInsets.only(top: 40.0),
      width: double.maxFinite,
      color: Colors.white,
      child: _buildFooterChildWidget(),
    );
  }

  /// ---- 构建尾部子部件
  Widget _buildFooterChildWidget() {
    return Container(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAgreementWidget(),
          _buildRegisterButtonWidget(),
        ],
      ),
    );
  }

  /// 构建协议部件
  Widget _buildAgreementWidget() {
    return AnimatedBuilder(
      animation: _offsetAnim,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(_offsetAnim.value, 0), // 1,0 水平移动 -- 0,1垂直移动
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Image.asset(
                  Constant.assetsImagesLogin +
                      (_checked
                          ? 'wcpay_lqt_protocol_selected_16x16.png'
                          : 'wcpay_lqt_protocol_not_selected_16x16.png'),
                  width: 16.0,
                  height: 16.0,
                ),
                onTap: () {
                  setState(() {
                    _checked = !_checked;
                  });
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
              ),
              SizedBox(width: 3),
              Text(
                '我已阅读并同意',
                style: TextStyle(color: Color(0xFF525458), fontSize: 13.0),
              ),
              InkWell(
                child: Text(
                  '《微信软件许可及服务协议》',
                  style: TextStyle(
                      color: Color(0xFF576b95),
                      fontSize: 13.0,
                      backgroundColor: _agreementHighlight
                          ? Color(0xFFc7c7c5)
                          : Colors.transparent),
                ),
                onHighlightChanged: (highlight) {
                  setState(() {
                    _agreementHighlight = highlight;
                  });
                },
                onTap: () {},
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建注册按钮部件
  Widget _buildRegisterButtonWidget() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 0),
      child: Opacity(
        opacity: _registerBtnDisabled ? 0.5 : 1,
        child: Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 24.0),
                color: Style.pTintColor,
                highlightColor: _registerBtnDisabled
                    ? Colors.transparent
                    : Style.sTintColor,
                splashColor: _registerBtnDisabled ? Colors.transparent : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                onPressed: _register,
                child: Text(
                  '注册',
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
}

//自定义 一个曲线  当然 也可以使用SDK提供的 如： Curves.fastOutSlowIn    抖动
class _MyCurve extends Curve {
  const _MyCurve([this.period = 1]); //抖动频率
  final double period;

  @override
  double transformInternal(double t) {
    final double s = period / 4.0;
    t = (2.0 * t - 1.0) * -1;
    double d = -1 *
        math.pow(2.0, 5.0 * t) *
        math.sin((t - s) * (math.pi * 2.0) / period);
    return d;
  }
}
