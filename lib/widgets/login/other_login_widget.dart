import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

class OtherLoginWidget extends StatefulWidget {
  OtherLoginWidget({Key key}) : super(key: key);

  _OtherLoginWidgetState createState() => _OtherLoginWidgetState();
}

class _OtherLoginWidgetState extends State<OtherLoginWidget> {
  // 切换登陆方式
  bool _showPasswordWay = true;

  // 切换名称
  String get _changeLoginName => _showPasswordWay ? "用微信号/QQ号/邮箱登录" : "用手机号登录";

  // loginBtnTitle
  String get _loginBtnTitle => _showPasswordWay ? "下一步" : "登录";

  // 屏幕宽
  double _screenWidth = 0;

  // 偏移量
  double _offsetLeft = 0;

  @override
  void initState() {
    super.initState();
    print('object');
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    _screenWidth = MediaQuery.of(context).size.width;
    return _buildChidWidgets();
  }

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
    print(_screenWidth);
    var duration = Duration(milliseconds: 250);
    return Container(
      width: double.maxFinite,
      height: 170.0,
      color: Colors.green,
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            left: _offsetLeft,
            top: 0,
            bottom: 0,
            width: _screenWidth,
            child: Container(
              color: Colors.red,
              child: Column(
                children: <Widget>[
                  Text('data'),
                  Text('data'),
                  Text('data'),
                  Text('data'),
                  Text('data'),
                  Text('data'),
                  Text('data'),
                ],
              ),
            ),
            duration: duration,
          ),
          AnimatedPositioned(
            left: _offsetLeft,
            top: 0,
            bottom: 0,
            width: _screenWidth,
            child: Container(
              color: Colors.orange,
              child: Column(
                children: <Widget>[
                  Text('data'),
                  Text('data'),
                  Text('data'),
                  Text('data'),
                  Text('data'),
                  Text('data'),
                  Text('data'),
                ],
              ),
            ),
            duration: duration,
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
            if (_showPasswordWay) {
              _offsetLeft = 0;
            } else {
              _offsetLeft = -_screenWidth;
            }
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
                onPressed: () {},
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
}

// Stack(
//         children: <Widget>[
//           Positioned(
//             left: 0,
//             top: 0,
//             child: Container(
//               color: Colors.green,
//               width: 200.0,
//               height: 60.0,
//             ),
//           )
//         ],
//       )
