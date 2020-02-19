import 'dart:wasm';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/constant/constant.dart';

// Standard iOS 10 tab bar height.
const double _kTabBarHeight = 50.0;

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
  /// 外表滚动
  ScrollController _controllerWrapper = new ScrollController();

  /// 内容滚动
  ScrollController _controllerContent = new ScrollController(
      initialScrollOffset: ScreenUtil().setHeight(60 * 3.0));

  /// 偏移量
  double _offset = 0.0;

  /// 内容开始偏移量 默认是 null
  double _startOffsetY;

  /// 是否正在滚动
  bool _isScrolling = false;

  /// 是否正在动画
  bool _isAnimating = false;

  // 焦点状态
  bool _focusState = false;
  set _focus(bool focus) {
    _focusState = focus;
    print('🔥🔥🔥🔥🔥🔥🔥88888 $focus');
  }

  // 小程序焦点状态
  bool _focusState1 = false;

  double _scaleBegin = 0.5;
  double _scaleEnd = 0.5;

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

    final offstage = widget.refreshing ? false : widget.offset < stage3Distance;

    double opacity = 0;
    // 处于第三阶段
    if (widget.refreshing) {
      if (_focusState) {
        // 拖拽状态下 控制透明度
        final step = 2.0 / H;
        opacity = 1.0 - step * _offset;
        if (opacity > 1.0) {
          opacity = 1.0;
        } else if (opacity < 0) {
          opacity = 0;
        }
      } else {
        if (_isScrolling) {
          opacity = .0;
        } else {
          opacity = 1.0;
          _scaleEnd = 1.0;
          if (!_controllerAnim.isAnimating) {
            _controllerAnim.forward();
          }
        }
      }
    } else {
      // 非刷新状态下
      _scaleBegin = 0.4;
      _scaleEnd = 0.4;

      // Fixed Bug: 这里要判断一下
      if (_controllerWrapper.hasClients && _controllerWrapper.offset != 0.0) {
        // 需要重置 offset
        _offset = 0.0;
        _controllerWrapper.jumpTo(0.0);
        if (_controllerAnim.isCompleted) {
          _controllerAnim.reset();
        }
      }

      // 将内容页 向上滚动 60
      if (_controllerContent.hasClients && _controllerContent.offset == 0.0) {
        // 需要重置 offset
        _controllerContent.jumpTo(ScreenUtil().setHeight(60 * 3.0));
      }

      //
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
        duration: Duration(
            milliseconds: widget.refreshing ? (_focusState ? 0 : 300) : 0),
        onEnd: () {},
        opacity: opacity,
        child: Container(
          width: double.infinity,
          height: H,
          decoration: BoxDecoration(
            // 设置渐变色
            gradient: widget.refreshing
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(39, 37, 57, 1),
                      Color.fromRGBO(56, 53, 76, 0.5),
                    ],
                  )
                : null,
          ),
          child: Scrollbar(
            child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                if (_isScrolling) {
                  return true;
                }
                if (notification is ScrollStartNotification) {
                  if (notification.dragDetails != null) {
                    _focus = true;
                  }
                  // 处理
                  _handlerOffset(notification.metrics.pixels);

                  // print(
                  // '😿 start_focus 👉 $_focusState  ${notification.metrics.pixels}');
                } else if (notification is ScrollUpdateNotification) {
                  // print(
                  //     '麻辣隔壁 👉 ${notification.dragDetails == null} $_focusState');
                  if (_focusState && notification.dragDetails == null) {
                    _isScrolling = true;
                    _focus = false;
                    _handlerOffset(notification.metrics.pixels);
                    // 更新UI
                    setState(() {});
                    _controllerWrapper
                        .animateTo(notification.metrics.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease)
                        .whenComplete(() {
                      _isScrolling = false;
                    });
                  } else {
                    // 处理
                    _handlerOffset(notification.metrics.pixels);
                  }
                } else if (notification is ScrollEndNotification) {
                  if (_focusState) {
                    _focus = false;

                    _isScrolling = true;

                    Future.delayed(
                      Duration(milliseconds: 10),
                      () async {
                        // 更新UI
                        setState(() {});
                        _handlerOffset(notification.metrics.pixels);
                        _controllerWrapper
                            .animateTo(notification.metrics.maxScrollExtent,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease)
                            .whenComplete(() {
                          _isScrolling = false;
                        });
                      },
                    );
                  } else {
                    // 处理
                    _handlerOffset(notification.metrics.pixels);
                  }
                }

                // 阻止冒泡
                return true;
              },
              child: ListView(
                controller: _controllerWrapper,
                padding: EdgeInsets.only(top: 0.0),
                children: <Widget>[
                  // 内容页
                  // 无动画 只����同时缩放 xy
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
                    scale: new Tween(begin: _scaleBegin, end: _scaleEnd)
                        .animate(_controllerAnim),
                    alignment: Alignment.topCenter,
                    child: _buildContentWidget(),
                  ),

                  // SizedBox
                  SizedBox(
                    height: 2 * H -
                        kToolbarHeight -
                        ScreenUtil.statusBarHeight -
                        ScreenUtil().setHeight(480 * 3.0),
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
    _controllerContent.dispose();
    _controllerWrapper.dispose();
    super.dispose();
  }

  /// ✨✨✨✨✨✨✨ 事件 ✨✨✨✨✨✨✨
  // 处理偏移逻辑
  void _handlerOffset(double offset) {
    // Fixed Bug: 非刷新状态下 do nothing...
    if (!widget.refreshing) return;

    // 计算
    if (offset > 0.0) {
      _offset = offset;
    } else if (_offset != 0.0) {
      _offset = 0.0;
    }

    if (widget.onScroll != null && widget.onScroll is Function) {
      // 将数据回调出��
      widget.onScroll(_offset, _focusState);
    }

    // 这里需要
    if (_focusState) {
      setState(() {});
    }
  }

  /// ✨✨✨✨✨✨✨ UI ✨✨✨✨✨✨✨

  /// 内容页
  Widget _buildContentWidget() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(480 * 3.0),
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
    return Container(
      height: ScreenUtil.statusBarHeight + ScreenUtil().setHeight(44.0 * 3),
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(42.0)),
      decoration: BoxDecoration(
        //  添加一条分割线
        border: Border(
            bottom: BorderSide(
                color:
                    widget.refreshing ? Color(0xFF2F2D45) : Colors.transparent,
                width: 0.5)),
      ),
      child: Text(
        '小程序',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: ScreenUtil().setSp(17 * 3),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// ���容页面
  Widget _buildAppletsWidget() {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        final offset = notification.metrics.pixels;
        // print('biu biu biu 11111 ---- $offset');

        if (notification is ScrollStartNotification) {
          if (notification.dragDetails != null) {
            _focusState1 = true;
            // 记录起始拖拽
            _startOffsetY = offset;
          }
        } else if (notification is ScrollUpdateNotification) {
          // 增加上拉 offset > 145 后，隐藏小程序模块
          if (_focusState1 && notification.dragDetails == null) {
            _focusState1 = false;
            if (offset > ScreenUtil().setHeight(145 * 3.0)) {
              if (widget.onScroll != null && widget.onScroll is Function) {
                // 将数据回调出��
                widget.onScroll(0, false);
                // 正在滚动中
                _isScrolling = true;
                // 开始滚动
                _controllerWrapper
                    .animateTo(_controllerWrapper.position.maxScrollExtent,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease)
                    .whenComplete(() {
                  _isScrolling = false;
                });
              }
            }
          }
        } else if (notification is ScrollEndNotification) {
          if (_focusState1) {
            _focusState1 = false;
            print('biu biu biu 444444 ---- $offset');
          }

          if (_startOffsetY != null &&
              offset != 0.0 &&
              offset < ScreenUtil().setHeight(60.0 * 3)) {
            // 如果小于 60 再去判断是 下拉 还是 上拉
            if ((offset - _startOffsetY) < 0) {
              // 下拉
              Future.delayed(
                Duration(milliseconds: 10),
                () async {
                  _controllerContent.animateTo(.0,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease);
                },
              );
            } else {
              // 上拉
              // Fixed Bug ： 记得延迟一丢丢，不然会报错 Why?
              Future.delayed(
                Duration(milliseconds: 10),
                () async {
                  _controllerContent.animateTo(ScreenUtil().setHeight(60.0 * 3),
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease);
                },
              );
            }
          }

          // 这里设置为null
          _startOffsetY = null;
        }
        return true; // 阻止冒泡
      },
      child: ListView(
        controller: _controllerContent,
        padding: EdgeInsets.only(top: 0),
        children: <Widget>[
          // 搜索框
          _buildSearchBarWidget(),
          // 最近使用
          _buildLocalAppletWidget(),
          // 我的小程序
          _buildAllAppletWidget(),

          // Fixed Bug: 给他加个盒子���让其能够滚动 隐藏搜索框
          SizedBox(
            height: ScreenUtil().setHeight(126 * 3.0),
          )
        ],
      ),
    );
  }

  /// 构建searchbar 17 + 41 + 17 = 58 + 17
  Widget _buildSearchBarWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(110.0),
          vertical: ScreenUtil().setHeight(51.0)),
      child: InkWell(
        child: Container(
          height: ScreenUtil().setHeight(123.0),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12.0))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SvgPicture.asset(
                Constant.assetsImagesSearch + 'icons_filled_search.svg',
                color: Colors.white30,
                width: ScreenUtil().setWidth(70.0),
                height: ScreenUtil().setWidth(70.0),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(18.0),
              ),
              Text(
                '搜索小程序',
                style: TextStyle(
                    color: Colors.white30,
                    fontSize: ScreenUtil().setSp(17.0 * 3.0)),
              )
            ],
          ),
        ),
        onTap: () {
          print('--- Click Nav Bar ---');
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
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(51.0),
            left: ScreenUtil().setWidth(135),
          ),
          child: Text(
            '最近使用',
            style: TextStyle(
              color: Color(0xFF88889e),
              fontSize: ScreenUtil().setSp(12.0 * 3.0),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(54.0),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(39.0 * 3),
            right: ScreenUtil().setWidth(39.0 * 3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildAppletItemWidget(
                  iconName: 'glory_of_kings.png', title: '王者荣耀', index: 0),
              _buildAppletItemWidget(
                  iconName: 'peace_elite.png', title: '和平精英', index: 1),
              _buildAppletItemWidget(
                  iconName: 'tencent_sports.png', title: '腾讯体育+', index: 2),
              _buildAppletItemWidget(
                  iconName: 'WAMainFrame_More_50x50.png', title: '', index: 3),
            ],
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
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(120.0),
            left: ScreenUtil().setWidth(135),
          ),
          child: Text(
            '我的小程序',
            style: TextStyle(
              color: Color(0xFF88889e),
              fontSize: ScreenUtil().setSp(12.0 * 3.0),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(54.0),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(39.0 * 3),
            right: ScreenUtil().setWidth(39.0 * 3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildAppletItemWidget(
                  iconName: 'peace_elite.png', title: '和平精英', index: 0),
              _buildAppletItemWidget(
                  iconName: 'glory_of_kings.png', title: '王者荣耀', index: 1),
              _buildAppletItemWidget(
                  iconName: 'tencent_sports.png', title: '腾讯体育+', index: 2),
              // 占位
              SizedBox(width: ScreenUtil().setWidth(60 * 3)),
            ],
          ),
        ),
      ],
    );
  }

  // 构建一个小程序
  Widget _buildAppletItemWidget({String iconName, String title, int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(24 * 3.0)),
          child: Image.asset(
            Constant.assetsImagesMainframe + iconName,
            width: ScreenUtil().setWidth(48 * 3.0),
            height: ScreenUtil().setWidth(48 * 3.0),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(9 * 3.0),
        ),
        Container(
          width: ScreenUtil().setWidth(180),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFE9E9EB),
              fontSize: ScreenUtil().setSp(12.0 * 3.0),
            ),
          ),
        ),
      ],
    );
  }
}
