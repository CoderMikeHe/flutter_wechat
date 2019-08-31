import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 主要用于 AppBar上 纯文字 的Button

class BarButton extends StatefulWidget {
  BarButton(
    this.text, {
    Key key,
    this.textColor,
    this.disabledTextColor,
    this.highlightTextColor,
    this.color = Colors.transparent,
    this.disabledColor = Colors.transparent,
    this.highlightColor = Colors.transparent,
    this.enabled = true,
    this.padding = const EdgeInsets.all(0.0),
    this.borderRadius,
    this.onTap,
  })  : assert(
          text != null,
          'A non-null String must be provided to a BarButton widget.',
        ),
        super(key: key);

  /// 显示文字
  final String text;

  /// 文字普通颜色
  final Color textColor;

  /// 文字禁用颜色
  final Color disabledTextColor;

  /// 文字高亮颜色
  final Color highlightTextColor;

  /// 按钮背景普通颜色
  final Color color;

  /// 按钮背景禁用颜色
  final Color disabledColor;

  /// 按钮背景高亮颜色
  final Color highlightColor;

  /// 是否允许点击 默认是true
  final bool enabled;

  /// 文字周围的内边距
  final EdgeInsets padding;

  /// 圆角
  final BorderRadiusGeometry borderRadius;

  /// 点击事件
  final VoidCallback onTap;

  _BarButtonState createState() => _BarButtonState();
}

class _BarButtonState extends State<BarButton> {
  /// 是否允许点击高亮
  bool _highlight = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled
          ? _handleTapDown
          : null, // Handle the tap events in the order that
      onTapUp: widget.enabled
          ? _handleTapUp
          : null, // they occur: down, up, tap, cancel
      onTap: widget.enabled ? widget.onTap : null,
      onTapCancel: widget.enabled ? _handleTapCancel : null,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.enabled
              ? (_highlight ? widget.highlightColor : widget.color)
              : widget.disabledColor,
          borderRadius: widget.borderRadius,
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 16.0,
            color: widget.enabled
                ? (_highlight ? widget.highlightTextColor : widget.textColor)
                : widget.disabledTextColor,
          ),
        ),
      ),
    );
  }

  /// 点击状态事件 they occur: down, up, tap, cancel
  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }
}
