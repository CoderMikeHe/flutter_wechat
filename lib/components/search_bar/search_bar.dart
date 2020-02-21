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
    this.onTap,
  }) : super(key: key);

  /// The SearchBar's internal padding.
  ///
  /// If null, `EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)` is used.
  final EdgeInsetsGeometry contentPadding;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback onTap;

  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  /// widget渲染监听。
  // WidgetUtil widgetUtil = new WidgetUtil();

  /// 用于获取文字高度
  GlobalKey _textKey = new GlobalKey();

  /// password控制输入
  final TextEditingController _passwordController =
      TextEditingController(text: '');

  /// 是否是编辑模式
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('searchbar build');
    // widgetUtil.asyncPrepare(context, true, (Rect rect) {
    // final RenderBox box = _textKey.currentContext.findRenderObject();
    // final size = box.size;

    // print('渲染完成  ${rect.size}  $size');
    // });

    return Container(
      padding: widget.contentPadding ??
          EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      width: FlutterScreenUtil.ScreenUtil.screenWidthDp,
      height: 56.0,
      // color: Colors.red,
      child: Container(
        height: 40.0,
        // width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              // right: 0,
              child: InkWell(
                child: Container(
                  height: 40.0,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: _SearchCube(),
                ),
                onTap: widget.onTap,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SearchCube extends StatelessWidget {
  const _SearchCube({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        Text(
          '搜索',
          style: TextStyle(
            color: Style.sTextColor,
          ),
        )
      ],
    );
  }
}
