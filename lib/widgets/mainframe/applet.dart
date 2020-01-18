import 'dart:wasm';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/constant/constant.dart';

class Applet extends StatefulWidget {
  Applet({Key key, this.offset, this.refreshing = false, this.onScroll})
      : super(key: key);

  /// 偏移量 >= 0
  final double offset;

  /// 是否是刷新状态
  final bool refreshing;

  /// 滚动回调
  final void Function(double offset, bool dragging) onScroll;

  // 构造
  _AppletState createState() => _AppletState();
}

class _AppletState extends State<Applet> with SingleTickerProviderStateMixin {
  /// 滚动
  ScrollController _controller = new ScrollController(initialScrollOffset: 50);

  /// 偏移量
  double _offset = 0.0;

  /// 开始偏移量
  double _startOffsetY = 0.0;

  // 焦点状态
  bool _focusState = false;
  set _focus(bool focus) {
    _focusState = focus;
    print('🔥🔥🔥🔥🔥🔥🔥 $focus');
  }

  bool _focusState1 = false;
  set _focus1(bool focus) {
    _focusState1 = focus;
    print('🔥🔥🔥🔥🔥🔥🔥 $focus');
  }

  double _scaleX = 0.5;
  double _scaleY = 0.5;

  // 动画控制器
  AnimationController _controllerAnim;

  @override
  void initState() {
    super.initState();

    _controllerAnim = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));

    _controllerAnim.addStatusListener((status) {
      print('object $status ');
    });
  }

  @override
  Widget build(BuildContext context) {
    final H = ScreenUtil.screenHeightDp;
    // 阶段III临界点
    final double stage3Distance = 130;
    // 阶段IV临界点
    final double stage4Distance = 180;

    final offstage = widget.offset < stage3Distance;

    double scaleX = 0.5;
    double scaleY = 0.5;
    double opacity = 0;
    // 处于第三阶段
    if (widget.refreshing) {
      opacity = 1.0;
      scaleX = 0.5;
      _scaleY = 1.0;

      print(
          'kkkkk  ${_controllerAnim.isCompleted} ${_controllerAnim.isDismissed}  ${_controllerAnim.isAnimating}');
      if (!_controllerAnim.isAnimating) {
        _controllerAnim.forward();
      }
    } else {
      final step = 0.5 / (stage4Distance - stage3Distance);
      opacity = 0 + step * (widget.offset - stage3Distance);
      if (opacity > 0.5) {
        opacity = 0.5;
      } else if (opacity < 0) {
        opacity = 0;
      }
    }

    return Offstage(
      offstage: offstage,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: widget.refreshing ? 300 : 0),
        onEnd: () {
          print(' ============== on end');
        },
        opacity: opacity,
        child: Container(
          width: double.infinity,
          height: H,
          color: Colors.transparent,
          child: Scrollbar(
            child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                print('object');
                if (notification is ScrollStartNotification) {
                  if (notification.dragDetails != null) {
                    _focus = true;
                  }

                  print(
                      'start_focus 👉 $_focusState  ${notification.metrics.pixels}');
                } else if (notification is ScrollUpdateNotification) {
                  if (_focusState && notification.dragDetails == null)
                    _focus = false;

                  print(
                      'Update_focus 👉 $_focusState  ${notification.metrics.pixels} ${notification.metrics.viewportDimension}');
                } else if (notification is ScrollEndNotification) {
                  if (_focusState) _focus = false;

                  print(
                      'End_focus 👉 $_focusState  ${notification.metrics.pixels} $_startOffsetY');
                }

                // 处理
                _handlerOffset(notification.metrics.pixels);

                // 阻止冒泡
                return true;
              },
              child: ListView(
                // padding: EdgeInsets.only(top: 0.0),
                children: <Widget>[
                  // 内容页
                  // 无动画 只能同时缩放 xy
                  // Transform.scale(
                  //   scale: 0.5,
                  //   origin: Offset(0, -280),
                  //   child: _buildContentWidget(),
                  // ),
                  // 无动画 能单独缩放 x 或 y
                  // Transform(
                  //   transform: Matrix4.diagonal3Values(scaleX, scaleY, 1.0),
                  //   origin: Offset(0, -280),
                  //   alignment: Alignment.center,
                  //   child: _buildContentWidget(),
                  // ),

                  ScaleTransition(
                    scale: new Tween(begin: _scaleX, end: _scaleY)
                        .animate(_controllerAnim),
                    alignment: Alignment.topCenter,
                    child: _buildContentWidget(),
                  ),

                  // SizedBox
                  SizedBox(
                    height: H - kToolbarHeight,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  /// ✨✨✨✨✨✨✨ 事件 ✨✨✨✨✨✨✨
  // 处理偏移逻辑
  Void _handlerOffset(double offset) {
    // 计算
    if (offset <= 0.0) {
      _offset = offset * -1;
    } else if (_offset != 0.0) {
      _offset = 0.0;
    }

    // 这里需要
    // setState(() {});
  }

  /// ✨✨✨✨✨✨✨ UI ✨✨✨✨✨✨✨

  /// 内容页
  Widget _buildContentWidget() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(500 * 3.0),
      color: Colors.greenAccent,
      child: Column(
        children: <Widget>[
          // navigation bar
          _buildNavigationBarWidget(),
          // 内容页
          Expanded(
            child: _buildAppletsWidget(),
          ),
        ],
      ),
    );
  }

  // 导航栏
  Widget _buildNavigationBarWidget() {
    return InkWell(
      child: Container(
        color: Colors.yellow,
        height: ScreenUtil.statusBarHeight + ScreenUtil().setHeight(40.0 * 3),
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 10),
        child: Text(
          '小程序',
          textAlign: TextAlign.center,
        ),
      ),
      onTap: () {
        print('00000000000');
        // _controller.animateTo(50,
        //     duration: Duration(milliseconds: 200), curve: Curves.ease);
        _scaleX = 0.5;
        _scaleY = 1.0;

        // setState(() {});
        _controllerAnim.forward();
      },
    );
  }

  /// 内容页面
  Widget _buildAppletsWidget() {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          if (notification.dragDetails != null) {
            _focus = true;
            // 记录起始拖拽
            _startOffsetY = notification.metrics.pixels;
          }

          print('start_focus 👉 $_focusState  ${notification.metrics.pixels}');
        } else if (notification is ScrollUpdateNotification) {
          if (_focusState && notification.dragDetails == null) _focus = false;

          print(
              'Update_focus 👉 $_focusState  ${notification.metrics.pixels} ${notification.metrics.viewportDimension}');
        } else if (notification is ScrollEndNotification) {
          if (_focusState) _focus = false;

          print(
              'End_focus 👉 $_focusState  ${notification.metrics.pixels} $_startOffsetY');

          final offset = notification.metrics.pixels;
          if (_startOffsetY != null &&
              offset != 0.0 &&
              offset < ScreenUtil().setHeight(50.0 * 3)) {
            // 如果小于 50 再去判断是 下拉 还是 上拉
            if ((offset - _startOffsetY) < 0) {
              // 下拉
              // Future.delayed(
              //   Duration(milliseconds: 200),
              //   () async {
              //     _controller.animateTo(.0,
              //         duration: Duration(milliseconds: 200),
              //         curve: Curves.ease);
              //   },
              // );
            } else {
              // 上拉
              // Fixed Bug ： 记得延迟一丢丢，不然会报错 Why?
              // Future.delayed(
              //   Duration(milliseconds: 200),
              //   () async {
              //     _controller.animateTo(ScreenUtil().setHeight(50.0 * 3),
              //         duration: Duration(milliseconds: 200),
              //         curve: Curves.ease);
              //   },
              // );
            }
          }
        }

        // 处理
        _handlerOffset(notification.metrics.pixels);

        return true; // 阻���冒泡
      },
      child: ListView(
        controller: _controller,
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(30.0),
          left: ScreenUtil().setWidth(37 * 3),
          right: ScreenUtil().setWidth(37 * 3),
        ),
        children: <Widget>[
          // 搜索框
          _buildSearchBarWidget(),
          SizedBox(height: ScreenUtil().setHeight(30 * 3)),
          // 最近使用
          _buildLocalAppletWidget(),
          SizedBox(height: ScreenUtil().setHeight(40 * 3)),
          // 我的小程序
          _buildAllAppletWidget(),
          // Fixed Bug: 给他加个盒子���让其能够滚动 隐藏搜索框
          SizedBox(
            height: 156,
          )
        ],
      ),
    );
  }

  /// 构建searchbar
  Widget _buildSearchBarWidget() {
    return Container(
      child: InkWell(
        child: Container(
          height: ScreenUtil().setHeight(120),
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12.0))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SvgPicture.asset(
                Constant.assetsImagesSearch + 'icons_filled_search.svg',
                color: Style.sTextColor,
                width: ScreenUtil().setWidth(60.0),
                height: ScreenUtil().setWidth(60.0),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(18.0),
              ),
              Text(
                '搜索小程序',
                style: TextStyle(
                    color: Style.sTextColor,
                    fontSize: ScreenUtil().setSp(14.0 * 3.0)),
              )
            ],
          ),
        ),
        onTap: () {
          print('object -------');
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
    );
  }

  /// 构建最近使用的小程序
  Widget _buildLocalAppletWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '最近使用',
          style: TextStyle(
            color: Color(0xFF88889e),
            fontSize: ScreenUtil().setSp(16.0 * 3.0),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(17 * 3.0),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildAppletItemWidget(
                  iconName: 'glory_of_kings.png', title: '王者荣耀'),
            ),
            Expanded(
              child: _buildAppletItemWidget(
                  iconName: 'peace_elite.png', title: '和平精英'),
            ),
            Expanded(
              child: _buildAppletItemWidget(
                  iconName: 'tencent_sports.png', title: '腾讯体育+'),
            ),
            Expanded(
              child: _buildAppletItemWidget(
                  iconName: 'WAMainFrame_More_50x50.png', title: ''),
            ),
          ],
        )
      ],
    );
  }

  // 构建一个小程序
  Widget _buildAppletItemWidget({String iconName, String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25 * 3.0)),
          child: Image.asset(
            Constant.assetsImagesMainframe + iconName,
            width: ScreenUtil().setWidth(50 * 3.0),
            height: ScreenUtil().setWidth(50 * 3.0),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(3 * 3.0),
        ),
        Container(
          width: ScreenUtil().setWidth(50 * 3.0),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: ScreenUtil().setSp(10.0 * 3.0),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建我的小程序
  Widget _buildAllAppletWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '我的小程序',
          style: TextStyle(
            color: Color(0xFF88889e),
            fontSize: ScreenUtil().setSp(16.0 * 3.0),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(17 * 3.0),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildAppletItemWidget(
                  iconName: 'peace_elite.png', title: '和平精英'),
            ),
            Expanded(
              child: _buildAppletItemWidget(
                  iconName: 'glory_of_kings.png', title: '王者荣耀'),
            ),
            Expanded(
              child: _buildAppletItemWidget(
                  iconName: 'tencent_sports.png', title: '腾讯体育+'),
            ),
            Expanded(
              child: SizedBox(
                width: ScreenUtil().setWidth(50 * 3),
              ),
            ),
          ],
        )
      ],
    );
  }
}
