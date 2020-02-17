import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/constant/constant.dart';

class Menus extends StatefulWidget {
  /// 构造函数
  Menus({Key key, this.show = false, this.onCallback}) : super(key: key);

  /// 显示隐藏
  final bool show;

  /// 回调数据
  /// [index] 要回调数据的索引 -1 代表点击蒙版
  final void Function(int index) onCallback;

  _MenusState createState() => _MenusState();
}

class _MenusState extends State<Menus> with SingleTickerProviderStateMixin {
  // 那个高亮的索引
  int _selectedIndex = -1;

  /// 是否需要动画
  bool _shouldAnimate = false;

  /// 缩放开始比例
  double _scaleBegin = 1.0;

  /// 缩放结束比例
  double _scaleEnd = 1.0;

  /// 动画控制器
  AnimationController _controller;

  /// 动画曲线
  CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();

    // 配置动画
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    _animation =
        new CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // 监听动画
    _controller.addStatusListener((AnimationStatus status) {
      print('addStatusListener $status');
      // 到达结束状态时  要回滚到开始状态
      if (status == AnimationStatus.completed) {
        // 正向结束, 重置到当前
        _controller.reset();

        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'object ------- ${widget.show} hhh--- ${_controller.isAnimating}  ${_controller.isCompleted}  ${_controller.isDismissed}');

    if (widget.show) {
      // 只有显示后 才需要缩放动画
      _shouldAnimate = true;
      _scaleBegin = _scaleEnd = 1.0;
    } else {
      _scaleBegin = 1.0;
      _scaleEnd = 0.5;
      // 处于开始阶段 且 需要动画
      if (_controller.isDismissed && _shouldAnimate) {
        _shouldAnimate = false;
        _controller.forward();
      } else {
        _scaleEnd = 1.0;
      }
    }

    // Fixed Bug: offstage 必须要等缩放动画结束后才去设置为 true, 否则 休想看到缩放动画
    return Offstage(
      offstage: !widget.show && _controller.isDismissed,
      child: InkWell(
        onTap: () {
          _onCallback(-1);
        },
        child: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.transparent,
          child: AnimatedOpacity(
            opacity: widget.show ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  right: 16,
                  child: Image.asset(
                    Constant.assetsImagesMainframe + 'menu_up_arrow.png',
                    width: ScreenUtil().setWidth(45.0),
                    height: ScreenUtil().setHeight(15.0),
                  ),
                ),
                Positioned(
                  top: ScreenUtil().setHeight(15.0),
                  right: ScreenUtil().setWidth(30.0),
                  width: ScreenUtil().setWidth(480.0),
                  child: ScaleTransition(
                    scale: new Tween(begin: _scaleBegin, end: _scaleEnd)
                        .animate(_animation),
                    alignment: Alignment(0.8, -1.0),
                    child: _buildMenuWidget(),
                  ),
                  // child: _buildMenuWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ✨✨✨✨✨✨✨ 事件 ✨✨✨✨✨✨✨
  void _onCallback(int index) {
    if (widget.onCallback != null && widget.onCallback is Function) {
      // 将数据回调出去
      widget.onCallback(index);
    }
  }

  /// ✨✨✨✨✨✨✨ UI ✨✨✨✨✨✨✨
  // 构建menu部件
  Widget _buildMenuWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(18.0)),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF4C4C4C),
        ),
        child: Column(
          children: <Widget>[
            _buildMenuItemWidget(
              icon: Constant.assetsImagesContacts + 'icons_filled_chats.svg',
              name: '发起群聊',
              index: 0,
            ),
            Divider(
              color: Colors.white30,
              height: 1,
              indent: ScreenUtil().setWidth(168.0),
            ),
            _buildMenuItemWidget(
              icon: Constant.assetsImagesContacts +
                  'icons_filled_add-friends.svg',
              name: '添加朋友',
              index: 1,
            ),
            Divider(
              color: Colors.white30,
              height: 1,
              indent: ScreenUtil().setWidth(168.0),
            ),
            _buildMenuItemWidget(
              icon: Constant.assetsImagesDiscover + 'icons_filled_scan.svg',
              name: '扫一扫',
              index: 2,
            ),
            Divider(
              color: Colors.white30,
              height: 1,
              indent: ScreenUtil().setWidth(168.0),
            ),
            _buildMenuItemWidget(
              icon: Constant.assetsImagesMainframe + 'icons_filled_pay.svg',
              name: '收付款',
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建menu子部件
  Widget _buildMenuItemWidget({String icon, String name = '', int index}) {
    return InkWell(
      onTap: () {
        // 回调数据
        _onCallback(index);
      },
      onHighlightChanged: (bool highlight) {
        _selectedIndex = highlight ? index : -1;
        setState(() {});
      },
      child: Container(
        constraints: BoxConstraints(minHeight: ScreenUtil().setHeight(168.0)),
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(75.0)),
        color: _selectedIndex == index ? Colors.black26 : Color(0xFF4C4C4C),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new SvgPicture.asset(
              icon,
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setWidth(60),
              color: Color(0xFFFFFFFF),
            ),
            SizedBox(width: ScreenUtil().setWidth(30.0)),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(48.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
