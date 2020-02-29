import 'package:flutter/material.dart';

import 'package:flustars/flustars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'
    as FlutterScreenUtil;

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/widgets/text_field/mh_text_field.dart';

class SearchBar extends StatefulWidget {
  SearchBar({
    Key key,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    this.onEdit,
    this.onCancel,
  }) : super(key: key);

  /// The SearchBar's internal padding.
  ///
  /// If null, `EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)` is used.
  final EdgeInsetsGeometry contentPadding;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback onEdit;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback onCancel;

  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  /// widget渲染监听。
  WidgetUtil widgetUtil = new WidgetUtil();

  /// 用于获取文字高度
  GlobalKey _textKey = new GlobalKey();

  /// password控制输入
  final TextEditingController _passwordController =
      TextEditingController(text: '');

  /// 是否是编辑模式
  bool _isEdit = false;

  /// 动画时间 0 无动画
  int _duration = 0;

  ///  是否正在动画中
  bool _isAnimating = false;

  /// 搜索图标距离左侧的距离
  double _searchIconLeft = 0;

  /// 控制键盘聚焦
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  // 事件处理
  // 编辑点击事件
  void _onEditTap() {
    // widget.onTap
    if (_isEdit) return;
    print('object..... onTap....');

    _duration = 300;
    _isEdit = true;
    _isAnimating = true;
    if (widget.onEdit != null && widget.onEdit is Function) {
      widget.onEdit();
    }

    // 弹出键盘
    _focusNode.requestFocus();
  }

  // 取消编辑事件
  void _onCancelTap() {
    if (!_isEdit) return;
    // cancel action...
    print('cancel action...');
    setState(() {
      _duration = 300;
      _isEdit = false;
    });

    if (widget.onCancel != null && widget.onCancel is Function) {
      widget.onCancel();
    }

    // 关闭键盘
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    print('searchbar build');
    widgetUtil.asyncPrepare(context, true, (Rect rect) {
      final RenderBox box = _textKey.currentContext.findRenderObject();
      final Size size = box.size;
      setState(() {
        _searchIconLeft = (rect.width - 16.0 - size.width) * .5;
      });
      print('渲染完成  ${rect.size}  ${size.width} ');
    });

    return Container(
      // padding: widget.contentPadding ??
      //     EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0, right: 0),
      width: FlutterScreenUtil.ScreenUtil.screenWidthDp,
      height: 56.0,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          // 白色框
          AnimatedPositioned(
            left: 0,
            right:
                _isEdit ? FlutterScreenUtil.ScreenUtil().setWidth(162.0) : 8.0,
            top: 0,
            bottom: 0,
            child: InkWell(
              onTap: _onEditTap,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
            ),
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: _duration),
          ),
          // 输入框
          Positioned(
            left: 0,
            top: -4,
            bottom: 0,
            right: FlutterScreenUtil.ScreenUtil().setWidth(162.0),
            child: Offstage(
              // 显示与否: 编辑非动画
              offstage: !_isEdit || _isAnimating,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 11.0 + 20.0 + 6.0,
                  ),
                  Expanded(
                    child: MHTextField(
                      hintText: "搜索",
                      focusNode: _focusNode,
                    ),
                  )
                ],
              ),
            ),
          ),
          // 搜索按钮
          AnimatedPositioned(
            top: 0,
            // Fixed Bug: left 必须有值，否则没的动画
            left: _isEdit
                ? FlutterScreenUtil.ScreenUtil().setWidth(33.0)
                : _searchIconLeft,
            bottom: 0,
            child: InkWell(
              onTap: _onEditTap,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: _SearchCube(
                key: _textKey,
                isEdit: _isEdit,
                isAnimating: _isAnimating,
              ),
            ),
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: _duration),
            onEnd: () {
              if (_duration > 0) {
                _isAnimating = false;

                setState(() {});
              }
            },
          ),
          // 取消按钮
          AnimatedPositioned(
            top: 0,
            right: _isEdit
                ? 0
                : -1 * FlutterScreenUtil.ScreenUtil().setWidth(162.0),
            bottom: 0,
            child: InkWell(
              onTap: _onCancelTap,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Container(
                alignment: Alignment.center,
                width: FlutterScreenUtil.ScreenUtil().setWidth(162.0),
                child: Text(
                  '取消',
                  style: TextStyle(
                    fontSize: FlutterScreenUtil.ScreenUtil().setSp(48.0),
                    color: Color(0xFF576B94),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: _duration),
          ),
        ],
      ),
    );
  }
}

class _SearchCube extends StatelessWidget {
  const _SearchCube({Key key, this.isEdit, this.isAnimating}) : super(key: key);

  /// 是否是编辑模式
  final bool isEdit;

  ///  是否正在动画中
  final bool isAnimating;
  @override
  Widget build(BuildContext context) {
    // 是否隐藏
    bool offstage = true;
    if (isEdit) {
      offstage = !isAnimating;
    } else {
      offstage = false;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          Constant.assetsImagesSearch + 'SearchContactsBarIcon_20x20.png',
          width: 20.0,
          height: 20.0,
        ),
        SizedBox(
          width: 6.0,
        ),
        Offstage(
          offstage: offstage,
          child: Text(
            '搜索',
            style: TextStyle(
              color: Color(0xFFb3b3b3),
              fontSize: 17.0,
            ),
          ),
        ),
      ],
    );
  }
}
