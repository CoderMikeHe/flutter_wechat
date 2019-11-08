// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// ActionSheetAction 文字样式
const TextStyle _kActionSheetActionStyle = TextStyle(
  fontFamily: '.SF UI Text',
  inherit: false,
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
  color: Color.fromRGBO(0, 0, 0, 0.9),
  textBaseline: TextBaseline.alphabetic,
);

const TextStyle _kActionSheetContentStyle = TextStyle(
  fontFamily: '.SF UI Text',
  inherit: false,
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
  color: _kContentTextColor,
  textBaseline: TextBaseline.alphabetic,
);

// This decoration is applied to the blurred backdrop to lighten the blurred
// image. Brightening is done to counteract the dark modal barrier that
// appears behind the alert. The overlay blend mode does the brightening.
// The white color doesn't paint any white, it's just the basis for the
// overlay blend mode.
const BoxDecoration _kAlertBlurOverlayDecoration = BoxDecoration(
  color: CupertinoColors.white,
  backgroundBlendMode: BlendMode.overlay,
);

// Translucent, very light gray that is painted on top of the blurred backdrop
// as the action sheet's background color.
const Color _kBackgroundColor = Color(0xD1F8F8F8);

// Translucent, light gray that is painted on top of the blurred backdrop as
// the background color of a pressed button.
const Color _kPressedColor = Color(0xFFECECEC);
const Color _kCancelButtonPressedColor = Color(0xFFECECEC);

// Translucent gray that is painted on top of the blurred backdrop in the gap
// areas between the content section and actions section, as well as between
// buttons.
const Color _kButtonDividerColor = Color(0x403F3F3F);

const Color _kContentTextColor = Color.fromRGBO(0, 0, 0, 0.5);

const double _kBlurAmount = 20.0;
const double _kEdgeHorizontalPadding = 0.0;

/// 取消按钮 顶部padding
const double _kCancelButtonPadding = 8.0;
const double _kEdgeVerticalPadding = 0.0;
const double _kContentHorizontalPadding = 24.0;
const double _kContentVerticalPadding = 16.0;

/// action button 最小高度
const double _kButtonHeight = 48.0;

/// 圆角
const double _kCornerRadius = 12.0;
// 分割线高度
const double _kDividerThickness = 1.0;

/// An iOS-style action sheet.
///
/// An action sheet is a specific style of alert that presents the user
/// with a set of two or more choices related to the current context.
/// An action sheet can have a title, an additional message, and a list
/// of actions. The title is displayed above the message and the actions
/// are displayed below this content.
///
/// This action sheet styles its title and message to match standard iOS action
/// sheet title and message text style.
///
/// To display action buttons that look like standard iOS action sheet buttons,
/// provide [ActionSheetAction]s for the [actions] given to this action sheet.
///
/// To include a iOS-style cancel button separate from the other buttons,
/// provide an [ActionSheetAction] for the [cancelButton] given to this
/// action sheet.
///
/// An action sheet is typically passed as the child widget to
/// [showCupertinoModalPopup], which displays the action sheet by sliding it up
/// from the bottom of the screen.
///
/// See also:
///
///  * [ActionSheetAction], which is an iOS-style action sheet button.
///  * <https://developer.apple.com/design/human-interface-guidelines/ios/views/action-sheets/>
class ActionSheet extends StatelessWidget {
  // 显示ActionSheet
  static show(
    BuildContext context, {
    Key key,
    Widget title,
    Widget message,
    List<Widget> actions,
    ScrollController messageScrollController,
    ScrollController actionScrollController,
    Widget cancelButton,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return ActionSheet(
          key: key,
          title: title,
          message: message,
          actions: actions,
          messageScrollController: messageScrollController,
          actionScrollController: actionScrollController,
          cancelButton: cancelButton,
        );
      },
    );
  }

  // 隐藏ActionSheet
  static hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Creates an iOS-style action sheet.
  ///
  /// An action sheet must have a non-null value for at least one of the
  /// following arguments: [actions], [title], [message], or [cancelButton].
  ///
  /// Generally, action sheets are used to give the user a choice between
  /// two or more choices for the current context.
  const ActionSheet({
    Key key,
    this.title,
    this.message,
    this.actions,
    this.messageScrollController,
    this.actionScrollController,
    this.cancelButton,
  })  : assert(
            actions != null ||
                title != null ||
                message != null ||
                cancelButton != null,
            'An action sheet must have a non-null value for at least one of the following arguments: '
            'actions, title, message, or cancelButton'),
        super(key: key);

  /// An optional title of the action sheet. When the [message] is non-null,
  /// the font of the [title] is bold.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// An optional descriptive message that provides more details about the
  /// reason for the alert.
  ///
  /// Typically a [Text] widget.
  final Widget message;

  /// The set of actions that are displayed for the user to select.
  ///
  /// Typically this is a list of [ActionSheetAction] widgets.
  final List<Widget> actions;

  /// A scroll controller that can be used to control the scrolling of the
  /// [message] in the action sheet.
  ///
  /// This attribute is typically not needed, as alert messages should be
  /// short.
  final ScrollController messageScrollController;

  /// A scroll controller that can be used to control the scrolling of the
  /// [actions] in the action sheet.
  ///
  /// This attribute is typically not needed.
  final ScrollController actionScrollController;

  /// The optional cancel button that is grouped separately from the other
  /// actions.
  ///
  /// Typically this is an [ActionSheetAction] widget.
  final Widget cancelButton;

  Widget _buildContent() {
    final List<Widget> content = <Widget>[];
    if (title != null || message != null) {
      final Widget titleSection = _AlertContentSection(
        title: title,
        message: message,
        scrollController: messageScrollController,
      );
      content.add(Flexible(child: titleSection));
    }

    return Container(
      color: _kBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: content,
      ),
    );
  }

  Widget _buildActions() {
    if (actions == null || actions.isEmpty) {
      return Container(
        height: 0.0,
      );
    }
    return Container(
      child: _CupertinoAlertActionSection(
        children: actions,
        scrollController: actionScrollController,
        hasCancelButton: cancelButton != null,
      ),
    );
  }

  Widget _buildCancelButton() {
    final double cancelPadding =
        (actions != null || message != null || title != null)
            ? _kCancelButtonPadding
            : 0.0;
    return Padding(
      padding: EdgeInsets.only(top: cancelPadding),
      child: _ActionSheetCancelButton(
        child: cancelButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      Flexible(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0.0),
          child: BackdropFilter(
            filter:
                ImageFilter.blur(sigmaX: _kBlurAmount, sigmaY: _kBlurAmount),
            child: Container(
              decoration: _kAlertBlurOverlayDecoration,
              child: _CupertinoAlertRenderWidget(
                contentSection: _buildContent(),
                actionsSection: _buildActions(),
              ),
            ),
          ),
        ),
      ),
    ];

    if (cancelButton != null) {
      children.add(
        _buildCancelButton(),
      );
    }

    final Orientation orientation = MediaQuery.of(context).orientation;
    double actionSheetWidth;
    if (orientation == Orientation.portrait) {
      actionSheetWidth =
          MediaQuery.of(context).size.width - (_kEdgeHorizontalPadding * 2);
    } else {
      actionSheetWidth =
          MediaQuery.of(context).size.height - (_kEdgeHorizontalPadding * 2);
    }

    return SafeArea(
      child: Semantics(
        namesRoute: true,
        scopesRoute: true,
        explicitChildNodes: true,
        label: 'Alert',
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_kCornerRadius),
            topRight: Radius.circular(_kCornerRadius),
          ),
          child: Container(
            width: actionSheetWidth,
            decoration: BoxDecoration(
              color: Color(0xFFEAE7E8),
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: _kEdgeHorizontalPadding,
              vertical: _kEdgeVerticalPadding,
            ),
            child: Column(
              children: children,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
        ),
      ),
    );
  }
}

/// A button typically used in a [ActionSheet].
///
/// See also:
///
///  * [ActionSheet], an alert that presents the user with a set of two or
///    more choices related to the current context.
class ActionSheetAction extends StatelessWidget {
  /// Creates an action for an iOS-style action sheet.
  ///
  /// The [child] and [onPressed] arguments must not be null.
  const ActionSheetAction({
    @required this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    @required this.child,
  })  : assert(child != null),
        assert(onPressed != null);

  /// The callback that is called when the button is tapped.
  ///
  /// This attribute must not be null.
  final VoidCallback onPressed;

  /// Whether this action is the default choice in the action sheet.
  ///
  /// Default buttons have bold text.
  final bool isDefaultAction;

  /// Whether this action might change or delete data.
  ///
  /// Destructive buttons have red text.
  final bool isDestructiveAction;

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    TextStyle style = _kActionSheetActionStyle;

    if (isDefaultAction) {
      style = style.copyWith(fontWeight: FontWeight.w600);
    }

    if (isDestructiveAction) {
      style = style.copyWith(color: Color(0xFFFA5151));
    }

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: _kButtonHeight,
        ),
        child: Semantics(
          button: true,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
            child: DefaultTextStyle(
              style: style,
              child: child,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

/// 取消按钮
class _ActionSheetCancelButton extends StatefulWidget {
  const _ActionSheetCancelButton({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _ActionSheetCancelButtonState createState() =>
      _ActionSheetCancelButtonState();
}

class _ActionSheetCancelButtonState extends State<_ActionSheetCancelButton> {
  Color _backgroundColor;

  @override
  void initState() {
    _backgroundColor = CupertinoColors.white;
    super.initState();
  }

  void _onTapDown(TapDownDetails event) {
    setState(() {
      _backgroundColor = _kCancelButtonPressedColor;
    });
  }

  void _onTapUp(TapUpDetails event) {
    setState(() {
      _backgroundColor = CupertinoColors.white;
    });
  }

  void _onTapCancel() {
    setState(() {
      _backgroundColor = CupertinoColors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      excludeFromSemantics: true,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(0),
        ),
        child: widget.child,
      ),
    );
  }
}

class _CupertinoAlertRenderWidget extends RenderObjectWidget {
  const _CupertinoAlertRenderWidget({
    Key key,
    @required this.contentSection,
    @required this.actionsSection,
  }) : super(key: key);

  final Widget contentSection;
  final Widget actionsSection;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCupertinoAlert(
      dividerThickness:
          _kDividerThickness / MediaQuery.of(context).devicePixelRatio,
    );
  }

  @override
  RenderObjectElement createElement() {
    return _CupertinoAlertRenderElement(this);
  }
}

class _CupertinoAlertRenderElement extends RenderObjectElement {
  _CupertinoAlertRenderElement(_CupertinoAlertRenderWidget widget)
      : super(widget);

  Element _contentElement;
  Element _actionsElement;

  @override
  _CupertinoAlertRenderWidget get widget => super.widget;

  @override
  _RenderCupertinoAlert get renderObject => super.renderObject;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_contentElement != null) {
      visitor(_contentElement);
    }
    if (_actionsElement != null) {
      visitor(_actionsElement);
    }
  }

  @override
  void mount(Element parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _contentElement = updateChild(
        _contentElement, widget.contentSection, _AlertSections.contentSection);
    _actionsElement = updateChild(
        _actionsElement, widget.actionsSection, _AlertSections.actionsSection);
  }

  @override
  void insertChildRenderObject(RenderObject child, _AlertSections slot) {
    _placeChildInSlot(child, slot);
  }

  @override
  void moveChildRenderObject(RenderObject child, _AlertSections slot) {
    _placeChildInSlot(child, slot);
  }

  @override
  void update(RenderObjectWidget newWidget) {
    super.update(newWidget);
    _contentElement = updateChild(
        _contentElement, widget.contentSection, _AlertSections.contentSection);
    _actionsElement = updateChild(
        _actionsElement, widget.actionsSection, _AlertSections.actionsSection);
  }

  @override
  void forgetChild(Element child) {
    assert(child == _contentElement || child == _actionsElement);
    if (_contentElement == child) {
      _contentElement = null;
    } else if (_actionsElement == child) {
      _actionsElement = null;
    }
  }

  @override
  void removeChildRenderObject(RenderObject child) {
    assert(child == renderObject.contentSection ||
        child == renderObject.actionsSection);
    if (renderObject.contentSection == child) {
      renderObject.contentSection = null;
    } else if (renderObject.actionsSection == child) {
      renderObject.actionsSection = null;
    }
  }

  void _placeChildInSlot(RenderObject child, _AlertSections slot) {
    assert(slot != null);
    switch (slot) {
      case _AlertSections.contentSection:
        renderObject.contentSection = child;
        break;
      case _AlertSections.actionsSection:
        renderObject.actionsSection = child;
        break;
    }
  }
}

// An iOS-style layout policy for sizing an alert's content section and action
// button section.
//
// The policy is as follows:
//
// If all content and buttons fit on the screen:
// The content section and action button section are sized intrinsically.
//
// If all content and buttons do not fit on the screen:
// A minimum height for the action button section is calculated. The action
// button section will not be rendered shorter than this minimum.  See
// _RenderCupertinoAlertActions for the minimum height calculation.
//
// With the minimum action button section calculated, the content section can
// take up as much of the remaining space as it needs.
//
// After the content section is laid out, the action button section is allowed
// to take up any remaining space that was not consumed by the content section.
class _RenderCupertinoAlert extends RenderBox {
  _RenderCupertinoAlert({
    RenderBox contentSection,
    RenderBox actionsSection,
    double dividerThickness = 0.0,
  })  : _contentSection = contentSection,
        _actionsSection = actionsSection,
        _dividerThickness = dividerThickness;

  RenderBox get contentSection => _contentSection;
  RenderBox _contentSection;
  set contentSection(RenderBox newContentSection) {
    if (newContentSection != _contentSection) {
      if (null != _contentSection) {
        dropChild(_contentSection);
      }
      _contentSection = newContentSection;
      if (null != _contentSection) {
        adoptChild(_contentSection);
      }
    }
  }

  RenderBox get actionsSection => _actionsSection;
  RenderBox _actionsSection;
  set actionsSection(RenderBox newActionsSection) {
    if (newActionsSection != _actionsSection) {
      if (null != _actionsSection) {
        dropChild(_actionsSection);
      }
      _actionsSection = newActionsSection;
      if (null != _actionsSection) {
        adoptChild(_actionsSection);
      }
    }
  }

  final double _dividerThickness;

  final Paint _dividerPaint = Paint()
    ..color = _kButtonDividerColor
    ..style = PaintingStyle.fill;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (null != contentSection) {
      contentSection.attach(owner);
    }
    if (null != actionsSection) {
      actionsSection.attach(owner);
    }
  }

  @override
  void detach() {
    super.detach();
    if (null != contentSection) {
      contentSection.detach();
    }
    if (null != actionsSection) {
      actionsSection.detach();
    }
  }

  @override
  void redepthChildren() {
    if (null != contentSection) {
      redepthChild(contentSection);
    }
    if (null != actionsSection) {
      redepthChild(actionsSection);
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (contentSection != null) {
      visitor(contentSection);
    }
    if (actionsSection != null) {
      visitor(actionsSection);
    }
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    final List<DiagnosticsNode> value = <DiagnosticsNode>[];
    if (contentSection != null) {
      value.add(contentSection.toDiagnosticsNode(name: 'content'));
    }
    if (actionsSection != null) {
      value.add(actionsSection.toDiagnosticsNode(name: 'actions'));
    }
    return value;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return constraints.minWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return constraints.maxWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double contentHeight = contentSection.getMinIntrinsicHeight(width);
    final double actionsHeight = actionsSection.getMinIntrinsicHeight(width);
    final bool hasDivider = contentHeight > 0.0 && actionsHeight > 0.0;
    double height =
        contentHeight + (hasDivider ? _dividerThickness : 0.0) + actionsHeight;

    if (actionsHeight > 0 || contentHeight > 0)
      height -= 2 * _kEdgeVerticalPadding;
    if (height.isFinite) return height;
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final double contentHeight = contentSection.getMaxIntrinsicHeight(width);
    final double actionsHeight = actionsSection.getMaxIntrinsicHeight(width);
    final bool hasDivider = contentHeight > 0.0 && actionsHeight > 0.0;
    double height =
        contentHeight + (hasDivider ? _dividerThickness : 0.0) + actionsHeight;

    if (actionsHeight > 0 || contentHeight > 0)
      height -= 2 * _kEdgeVerticalPadding;
    if (height.isFinite) return height;
    return 0.0;
  }

  @override
  void performLayout() {
    final bool hasDivider =
        contentSection.getMaxIntrinsicHeight(constraints.maxWidth) > 0.0 &&
            actionsSection.getMaxIntrinsicHeight(constraints.maxWidth) > 0.0;
    final double dividerThickness = hasDivider ? _dividerThickness : 0.0;

    final double minActionsHeight =
        actionsSection.getMinIntrinsicHeight(constraints.maxWidth);

    // Size alert content.
    contentSection.layout(
      constraints.deflate(
          EdgeInsets.only(bottom: minActionsHeight + dividerThickness)),
      parentUsesSize: true,
    );
    final Size contentSize = contentSection.size;

    // Size alert actions.
    actionsSection.layout(
      constraints
          .deflate(EdgeInsets.only(top: contentSize.height + dividerThickness)),
      parentUsesSize: true,
    );
    final Size actionsSize = actionsSection.size;

    // Calculate overall alert height.
    final double actionSheetHeight =
        contentSize.height + dividerThickness + actionsSize.height;

    // Set our size now that layout calculations are complete.
    size = Size(constraints.maxWidth, actionSheetHeight);

    // Set the position of the actions box to sit at the bottom of the alert.
    // The content box defaults to the top left, which is where we want it.
    assert(actionsSection.parentData is MultiChildLayoutParentData);
    final MultiChildLayoutParentData actionParentData =
        actionsSection.parentData;
    actionParentData.offset =
        Offset(0.0, contentSize.height + dividerThickness);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final MultiChildLayoutParentData contentParentData =
        contentSection.parentData;
    contentSection.paint(context, offset + contentParentData.offset);

    final bool hasDivider =
        contentSection.size.height > 0.0 && actionsSection.size.height > 0.0;
    if (hasDivider) {
      _paintDividerBetweenContentAndActions(context.canvas, offset);
    }

    final MultiChildLayoutParentData actionsParentData =
        actionsSection.parentData;
    actionsSection.paint(context, offset + actionsParentData.offset);
  }

  void _paintDividerBetweenContentAndActions(Canvas canvas, Offset offset) {
    canvas.drawRect(
      Rect.fromLTWH(
        offset.dx,
        offset.dy + contentSection.size.height,
        size.width,
        _dividerThickness,
      ),
      _dividerPaint,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    final MultiChildLayoutParentData contentSectionParentData =
        contentSection.parentData;
    final MultiChildLayoutParentData actionsSectionParentData =
        actionsSection.parentData;
    return result.addWithPaintOffset(
          offset: contentSectionParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - contentSectionParentData.offset);
            return contentSection.hitTest(result, position: transformed);
          },
        ) ||
        result.addWithPaintOffset(
          offset: actionsSectionParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - actionsSectionParentData.offset);
            return actionsSection.hitTest(result, position: transformed);
          },
        );
  }
}

// Visual components of an alert that need to be explicitly sized and
// laid out at runtime.
enum _AlertSections {
  contentSection,
  actionsSection,
}

// The "content section" of a ActionSheet.
//
// If title is missing, then only content is added.  If content is
// missing, then only a title is added. If both are missing, then it returns
// a SingleChildScrollView with a zero-sized Container.
class _AlertContentSection extends StatelessWidget {
  const _AlertContentSection({
    Key key,
    this.title,
    this.message,
    this.scrollController,
  }) : super(key: key);

  // An optional title of the action sheet. When the message is non-null,
  // the font of the title is bold.
  //
  // Typically a Text widget.
  final Widget title;

  // An optional descriptive message that provides more details about the
  // reason for the alert.
  //
  // Typically a Text widget.
  final Widget message;

  // A scroll controller that can be used to control the scrolling of the
  // content in the action sheet.
  //
  // Defaults to null, and is typically not needed, since most alert contents
  // are short.
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final List<Widget> titleContentGroup = <Widget>[];
    if (title != null) {
      titleContentGroup.add(Padding(
        padding: const EdgeInsets.only(
          left: _kContentHorizontalPadding,
          right: _kContentHorizontalPadding,
          bottom: _kContentVerticalPadding,
          top: _kContentVerticalPadding,
        ),
        child: DefaultTextStyle(
          style: message == null
              ? _kActionSheetContentStyle
              : _kActionSheetContentStyle.copyWith(fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
          child: title,
        ),
      ));
    }

    if (message != null) {
      titleContentGroup.add(
        Padding(
          padding: EdgeInsets.only(
            left: _kContentHorizontalPadding,
            right: _kContentHorizontalPadding,
            bottom: title == null
                ? _kContentVerticalPadding
                : _kContentVerticalPadding,
            top: title == null ? _kContentVerticalPadding : 0.0,
          ),
          child: DefaultTextStyle(
            style: title == null
                ? _kActionSheetContentStyle.copyWith(
                    fontWeight: FontWeight.w400)
                : _kActionSheetContentStyle,
            textAlign: TextAlign.center,
            child: message,
          ),
        ),
      );
    }

    if (titleContentGroup.isEmpty) {
      return SingleChildScrollView(
        controller: scrollController,
        child: Container(
          width: 0.0,
          height: 0.0,
        ),
      );
    }

    // Add padding between the widgets if necessary.
    if (titleContentGroup.length > 1) {
      titleContentGroup.insert(
          1, const Padding(padding: EdgeInsets.only(top: 8.0)));
    }

    return CupertinoScrollbar(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: titleContentGroup,
        ),
      ),
    );
  }
}

// The "actions section" of a ActionSheet.
//
// See _RenderCupertinoAlertActions for details about action button sizing
// and layout.
class _CupertinoAlertActionSection extends StatefulWidget {
  const _CupertinoAlertActionSection({
    Key key,
    @required this.children,
    this.scrollController,
    this.hasCancelButton,
  })  : assert(children != null),
        super(key: key);

  final List<Widget> children;

  // A scroll controller that can be used to control the scrolling of the
  // actions in the action sheet.
  //
  // Defaults to null, and is typically not needed, since most alerts
  // don't have many actions.
  final ScrollController scrollController;

  final bool hasCancelButton;

  @override
  _CupertinoAlertActionSectionState createState() =>
      _CupertinoAlertActionSectionState();
}

class _CupertinoAlertActionSectionState
    extends State<_CupertinoAlertActionSection> {
  @override
  Widget build(BuildContext context) {
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    final List<Widget> interactiveButtons = <Widget>[];
    for (int i = 0; i < widget.children.length; i += 1) {
      interactiveButtons.add(
        _PressableActionButton(
          child: widget.children[i],
        ),
      );
    }

    return CupertinoScrollbar(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: _CupertinoAlertActionsRenderWidget(
          actionButtons: interactiveButtons,
          dividerThickness: _kDividerThickness / devicePixelRatio,
          hasCancelButton: widget.hasCancelButton,
        ),
      ),
    );
  }
}

// A button that updates its render state when pressed.
//
// The pressed state is forwarded to an _ActionButtonParentDataWidget. The
// corresponding _ActionButtonParentData is then interpreted and rendered
// appropriately by _RenderCupertinoAlertActions.
class _PressableActionButton extends StatefulWidget {
  const _PressableActionButton({
    @required this.child,
  });

  final Widget child;

  @override
  _PressableActionButtonState createState() => _PressableActionButtonState();
}

class _PressableActionButtonState extends State<_PressableActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return _ActionButtonParentDataWidget(
      isPressed: _isPressed,
      // TODO(mattcarroll): Button press dynamics need overhaul for iOS: https://github.com/flutter/flutter/issues/19786
      child: GestureDetector(
        excludeFromSemantics: true,
        behavior: HitTestBehavior.opaque,
        onTapDown: (TapDownDetails details) =>
            setState(() => _isPressed = true),
        onTapUp: (TapUpDetails details) => setState(() => _isPressed = false),
        // TODO(mattcarroll): Cancel is currently triggered when user moves past slop instead of off button: https://github.com/flutter/flutter/issues/19783
        onTapCancel: () => setState(() => _isPressed = false),
        child: widget.child,
      ),
    );
  }
}

// ParentDataWidget that updates _ActionButtonParentData for an action button.
//
// Each action button requires knowledge of whether or not it is pressed so that
// the alert can correctly render the button. The pressed state is held within
// _ActionButtonParentData. _ActionButtonParentDataWidget is responsible for
// updating the pressed state of an _ActionButtonParentData based on the
// incoming isPressed property.
class _ActionButtonParentDataWidget
    extends ParentDataWidget<_CupertinoAlertActionsRenderWidget> {
  const _ActionButtonParentDataWidget({
    Key key,
    this.isPressed,
    @required Widget child,
  }) : super(key: key, child: child);

  final bool isPressed;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is _ActionButtonParentData);
    final _ActionButtonParentData parentData = renderObject.parentData;
    if (parentData.isPressed != isPressed) {
      parentData.isPressed = isPressed;

      // Force a repaint.
      final AbstractNode targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsPaint();
    }
  }
}

// ParentData applied to individual action buttons that report whether or not
// that button is currently pressed by the user.
class _ActionButtonParentData extends MultiChildLayoutParentData {
  _ActionButtonParentData({
    this.isPressed = false,
  });

  bool isPressed;
}

// An iOS-style alert action button layout.
//
// See _RenderCupertinoAlertActions for specific layout policy details.
class _CupertinoAlertActionsRenderWidget extends MultiChildRenderObjectWidget {
  _CupertinoAlertActionsRenderWidget({
    Key key,
    @required List<Widget> actionButtons,
    double dividerThickness = 0.0,
    bool hasCancelButton = false,
  })  : _dividerThickness = dividerThickness,
        _hasCancelButton = hasCancelButton,
        super(key: key, children: actionButtons);

  final double _dividerThickness;
  final bool _hasCancelButton;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCupertinoAlertActions(
      dividerThickness: _dividerThickness,
      hasCancelButton: _hasCancelButton,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderCupertinoAlertActions renderObject) {
    renderObject.dividerThickness = _dividerThickness;
    renderObject.hasCancelButton = _hasCancelButton;
  }
}

// An iOS-style layout policy for sizing and positioning an action sheet's
// buttons.
//
// The policy is as follows:
//
// Action sheet buttons are always stacked vertically. In the case where the
// content section and the action section combined can not fit on the screen
// without scrolling, the height of the action section is determined as
// follows.
//
// If the user has included a separate cancel button, the height of the action
// section can be up to the height of 3 action buttons (i.e., the user can
// include 1, 2, or 3 action buttons and they will appear without needing to
// be scrolled). If 4+ action buttons are provided, the height of the action
// section shrinks to 1.5 buttons tall, and is scrollable.
//
// If the user has not included a separate cancel button, the height of the
// action section is at most 1.5 buttons tall.
class _RenderCupertinoAlertActions extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  _RenderCupertinoAlertActions({
    List<RenderBox> children,
    double dividerThickness = 0.0,
    bool hasCancelButton = false,
  })  : _dividerThickness = dividerThickness,
        _hasCancelButton = hasCancelButton {
    addAll(children);
  }

  // The thickness of the divider between buttons.
  double get dividerThickness => _dividerThickness;
  double _dividerThickness;
  set dividerThickness(double newValue) {
    if (newValue == _dividerThickness) {
      return;
    }

    _dividerThickness = newValue;
    markNeedsLayout();
  }

  bool _hasCancelButton;
  bool get hasCancelButton => _hasCancelButton;
  set hasCancelButton(bool newValue) {
    if (newValue == _hasCancelButton) {
      return;
    }

    _hasCancelButton = newValue;
    markNeedsLayout();
  }

  final Paint _buttonBackgroundPaint = Paint()
    ..color = _kBackgroundColor
    ..style = PaintingStyle.fill;

  final Paint _pressedButtonBackgroundPaint = Paint()
    ..color = _kPressedColor
    ..style = PaintingStyle.fill;

  final Paint _dividerPaint = Paint()
    ..color = _kButtonDividerColor
    ..style = PaintingStyle.fill;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ActionButtonParentData)
      child.parentData = _ActionButtonParentData();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return constraints.minWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return constraints.maxWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (childCount == 0) return 0.0;
    if (childCount == 1)
      return firstChild.computeMaxIntrinsicHeight(width) + dividerThickness;
    if (hasCancelButton && childCount < 4)
      return _computeMinIntrinsicHeightWithCancel(width);
    return _computeMinIntrinsicHeightWithoutCancel(width);
  }

  // The minimum height for more than 2-3 buttons when a cancel button is
  // included is the full height of button stack.
  double _computeMinIntrinsicHeightWithCancel(double width) {
    assert(childCount == 2 || childCount == 3);
    if (childCount == 2) {
      return firstChild.getMinIntrinsicHeight(width) +
          childAfter(firstChild).getMinIntrinsicHeight(width) +
          dividerThickness;
    }
    return firstChild.getMinIntrinsicHeight(width) +
        childAfter(firstChild).getMinIntrinsicHeight(width) +
        childAfter(childAfter(firstChild)).getMinIntrinsicHeight(width) +
        (dividerThickness * 2);
  }

  // The minimum height for more than 2 buttons when no cancel button or 4+
  // buttons when a cancel button is included is the height of the 1st button
  // + 50% the height of the 2nd button + 2 dividers.
  double _computeMinIntrinsicHeightWithoutCancel(double width) {
    assert(childCount >= 2);
    return firstChild.getMinIntrinsicHeight(width) +
        dividerThickness +
        (0.5 * childAfter(firstChild).getMinIntrinsicHeight(width));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (childCount == 0) return 0.0;
    if (childCount == 1)
      return firstChild.computeMaxIntrinsicHeight(width) + dividerThickness;
    return _computeMaxIntrinsicHeightStacked(width);
  }

  // Max height of a stack of buttons is the sum of all button heights + a
  // divider for each button.
  double _computeMaxIntrinsicHeightStacked(double width) {
    assert(childCount >= 2);

    final double allDividersHeight = (childCount - 1) * dividerThickness;
    double heightAccumulation = allDividersHeight;
    RenderBox button = firstChild;
    while (button != null) {
      heightAccumulation += button.getMaxIntrinsicHeight(width);
      button = childAfter(button);
    }
    return heightAccumulation;
  }

  @override
  void performLayout() {
    final BoxConstraints perButtonConstraints = constraints.copyWith(
      minHeight: 0.0,
      maxHeight: double.infinity,
    );

    RenderBox child = firstChild;
    int index = 0;
    double verticalOffset = 0.0;
    while (child != null) {
      child.layout(
        perButtonConstraints,
        parentUsesSize: true,
      );

      assert(child.parentData is MultiChildLayoutParentData);
      final MultiChildLayoutParentData parentData = child.parentData;
      parentData.offset = Offset(0.0, verticalOffset);

      verticalOffset += child.size.height;
      if (index < childCount - 1) {
        // Add a gap for the next divider.
        verticalOffset += dividerThickness;
      }

      index += 1;
      child = childAfter(child);
    }

    size = constraints.constrain(Size(constraints.maxWidth, verticalOffset));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    _drawButtonBackgroundsAndDividersStacked(canvas, offset);
    _drawButtons(context, offset);
  }

  void _drawButtonBackgroundsAndDividersStacked(Canvas canvas, Offset offset) {
    final Offset dividerOffset = Offset(0.0, dividerThickness);

    final Path backgroundFillPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    final Path pressedBackgroundFillPath = Path();

    final Path dividersPath = Path();

    Offset accumulatingOffset = offset;

    RenderBox child = firstChild;
    RenderBox prevChild;
    while (child != null) {
      assert(child.parentData is _ActionButtonParentData);
      final _ActionButtonParentData currentButtonParentData = child.parentData;
      final bool isButtonPressed = currentButtonParentData.isPressed;

      bool isPrevButtonPressed = false;
      if (prevChild != null) {
        assert(prevChild.parentData is _ActionButtonParentData);
        final _ActionButtonParentData previousButtonParentData =
            prevChild.parentData;
        isPrevButtonPressed = previousButtonParentData.isPressed;
      }

      final bool isDividerPresent = child != firstChild;
      final bool isDividerPainted =
          isDividerPresent && !(isButtonPressed || isPrevButtonPressed);
      final Rect dividerRect = Rect.fromLTWH(
        accumulatingOffset.dx,
        accumulatingOffset.dy,
        size.width,
        _dividerThickness,
      );

      final Rect buttonBackgroundRect = Rect.fromLTWH(
        accumulatingOffset.dx,
        accumulatingOffset.dy + (isDividerPresent ? dividerThickness : 0.0),
        size.width,
        child.size.height,
      );

      // If this button is pressed, then we don't want a white background to be
      // painted, so we erase this button from the background path.
      if (isButtonPressed) {
        backgroundFillPath.addRect(buttonBackgroundRect);
        pressedBackgroundFillPath.addRect(buttonBackgroundRect);
      }

      // If this divider is needed, then we erase the divider area from the
      // background path, and on top of that we paint a translucent gray to
      // darken the divider area.
      if (isDividerPainted) {
        backgroundFillPath.addRect(dividerRect);
        dividersPath.addRect(dividerRect);
      }

      accumulatingOffset += (isDividerPresent ? dividerOffset : Offset.zero) +
          Offset(0.0, child.size.height);

      prevChild = child;
      child = childAfter(child);
    }

    canvas.drawPath(backgroundFillPath, _buttonBackgroundPaint);
    canvas.drawPath(pressedBackgroundFillPath, _pressedButtonBackgroundPaint);
    canvas.drawPath(dividersPath, _dividerPaint);
  }

  void _drawButtons(PaintingContext context, Offset offset) {
    RenderBox child = firstChild;
    while (child != null) {
      final MultiChildLayoutParentData childParentData = child.parentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childAfter(child);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
