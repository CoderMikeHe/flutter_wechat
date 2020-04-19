import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class MHListTile extends StatefulWidget {
  /// Creates a list tile.
  ///
  /// If [isThreeLine] is true, then [subtitle] must not be null.
  ///
  /// Requires one of its ancestors to be a [Material] widget.
  const MHListTile({
    Key key,
    this.leading,
    this.middle,
    this.trailing,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.enabled = true,
    this.disabledColor = const Color(0xFFE5E5E5),
    this.onTap,
    this.onTapValue,
    this.onLongPress,
    this.onLongPressValue,
    this.callbackContext,
    this.selected = false,
    this.selectedColor = const Color(0xFFE5E5E5),
    this.allowTap = true,
    this.tapedColor = const Color(0xFFE5E5E5),
    this.dividerIndent = 0.0,
    this.dividerEndIndent = 0.0,
    this.dividerHeight = 0.5,
    this.dividerColor = const Color(0xFFD8D8D8),
    this.height,
  })  : assert(enabled != null),
        assert(selected != null),
        assert(allowTap != null),
        super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap.
  final Widget middle;

  /// A widget to display after the title.
  ///
  /// Typically an [Icon] widget.
  ///
  /// To show right-aligned metadata (assuming left-to-right reading order;
  /// left-aligned for right-to-left reading order), consider using a [Row] with
  /// [MainAxisAlign.baseline] alignment whose first item is [Expanded] and
  /// whose second child is the metadata text, instead of using the [trailing]
  /// property.
  final Widget trailing;

  /// The tile's internal padding.
  ///
  /// Insets a [ListTile]'s contents: its [leading], [title], [subtitle],
  /// and [trailing] widgets.
  ///
  /// If null, `EdgeInsets.symmetric(horizontal: 16.0)` is used.
  final EdgeInsetsGeometry contentPadding;

  /// Whether this list tile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color from the
  /// current [Theme] and the [onTap] and [onLongPress] callbacks are
  /// inoperative.
  final bool enabled;

  /// When [enabled] is false, the background color
  ///
  /// default is 0xFFE5E5E5
  final Color disabledColor;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback onTap;
  final void Function(BuildContext context) onTapValue;

  /// Called when the user long-presses on this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureLongPressCallback onLongPress;
  final void Function(BuildContext context) onLongPressValue;

  /// 回调 BuildContext context 用于侧滑
  final void Function(BuildContext context) callbackContext;

  /// If this tile is also [enabled] then icons and text are rendered with the same color.
  ///
  /// By default the selected color is the theme's primary color. The selected color [selectedColor]
  final bool selected;

  /// When [selected] is false, the background color,
  ///
  /// default is 0xFFE5E5E5
  final Color selectedColor;

  /// 是否允许用户 tap
  ///
  /// default is true
  final bool allowTap;

  /// When [allowTap] is false, the background color,
  ///
  /// default is 0xFFE5E5E5
  final Color tapedColor;

  /// 分割线高度 default is 0.5
  final double dividerHeight;

  /// 分割线颜色 default is 0xFFD8D8D8
  final Color dividerColor;

  /// 分割线相对头部偏移量 default is 0.0
  final double dividerIndent;

  /// 分割线相对尾部偏移量 default is 0.0
  final double dividerEndIndent;

  /// The tile's internal height.
  final double height;

  _MHListTileState createState() => _MHListTileState();
}

class _MHListTileState extends State<MHListTile> {
  /// 是否允许点击高亮
  bool _highlight = false;

  @override
  Widget build(BuildContext context) {
    if (widget.callbackContext != null && widget.callbackContext is Function) {
      widget.callbackContext(context);
    }
    return Container(
      color: Colors.white,
      child: _buildChildWidget(),
    );
  }

  /// 构建子部件
  Widget _buildChildWidget() {
    return Column(
      children: <Widget>[
        _buildItemWidget(),
        _buildDividerWidget(),
      ],
    );
  }

  /// 构建子itemWidget
  Widget _buildItemWidget() {
    return GestureDetector(
      onTapDown: (widget.allowTap && widget.enabled && !widget.selected)
          ? _handleTapDown
          : null, // Handle the tap events in the order that
      onTapUp: (widget.allowTap && widget.enabled && !widget.selected)
          ? _handleTapUp
          : null, // they occur: down, up, tap, cancel
      onTap: widget.enabled
          ? () {
              if (widget.onTapValue != null && widget.onTapValue is Function) {
                widget.onTapValue(context);
              } else if (widget.onTap != null && widget.onTap is Function) {
                widget.onTap();
              }
            }
          : null,
      onLongPress: widget.enabled
          ? () {
              if (widget.onLongPressValue != null &&
                  widget.onLongPressValue is Function) {
                widget.onTapValue(context);
              } else if (widget.onLongPress != null &&
                  widget.onLongPress is Function) {
                widget.onTap();
              }
            }
          : null,
      onTapCancel: (widget.allowTap && widget.enabled && !widget.selected)
          ? _handleTapCancel
          : null,
      child: Container(
        height: widget.height == null
            ? null
            : widget.height - (widget.dividerHeight ?? 0.5),
        color: _fetchColor(),
        padding:
            widget.contentPadding ?? EdgeInsets.symmetric(horizontal: 16.0),
        child: _buildItem(),
      ),
    );
  }

  /// 获取背景色
  Color _fetchColor() {
    if (widget.enabled) {
      if (widget.selected) {
        return widget.selectedColor;
      } else {
        return _highlight ? widget.tapedColor : Color(0xFFFFFFFF);
      }
    } else {
      return widget.disabledColor;
    }
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

  /// 返回 item
  Widget _buildItem() {
    final List<Widget> children = [];

    if (widget.leading != null) {
      children.add(widget.leading);
    }

    if (widget.middle != null) {
      children.add(Expanded(
        child: widget.middle,
      ));
    }

    if (widget.trailing != null) {
      children.add(widget.trailing);
    }

    return Row(
      children: children,
    );
  }

  /// 构建分割线
  Widget _buildDividerWidget() {
    return Divider(
      height: widget.dividerHeight ?? 0.5,
      color: widget.dividerColor ?? Color(0xFFD8D8D8),
      indent: widget.dividerIndent ?? 0.0,
      endIndent: widget.dividerEndIndent ?? 0.0,
    );
  }
}
