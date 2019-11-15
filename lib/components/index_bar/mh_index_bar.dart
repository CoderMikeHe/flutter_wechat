import 'package:flutter/material.dart';

/// IndexBar touch callback IndexModel.
typedef void IndexBarTouchCallback(IndexBarDetails model);

/// IndexModel.
class IndexBarDetails {
  String tag; //current touch tag.
  int position; //current touch position.
  bool isTouchDown; //is touch down.

  IndexBarDetails({this.tag, this.position, this.isTouchDown});
}

///Default Index data.
const List<String> INDEX_DATA_DEF = const [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "#"
];

/// IndexBar.
class IndexBar extends StatefulWidget {
  IndexBar(
      {Key key,
      this.data = INDEX_DATA_DEF,
      @required this.onTouch,
      this.width = 20,
      this.tag = '',
      this.ignoreTags = const [],
      this.itemHeight = 16,
      this.color = Colors.transparent,
      this.textStyle =
          const TextStyle(fontSize: 10.0, color: Color(0xFF666666)),
      this.touchDownColor = const Color(0xffeeeeee),
      this.touchDownTextStyle =
          const TextStyle(fontSize: 10.0, color: Colors.black)});

  /// index data.
  final List<String> data;

  /// 当前高亮显示的标签
  final String tag;

  /// 忽略的Tags，这些忽略Tag, 不会高亮显示，点击或长按 不会弹出 tagHint
  final List<String> ignoreTags;

  /// IndexBar width(def:30).
  final int width;

  /// IndexBar item height(def:16).
  final int itemHeight;

  /// Background color
  final Color color;

  /// IndexBar touch down color.
  final Color touchDownColor;

  /// IndexBar text style.
  final TextStyle textStyle;

  final TextStyle touchDownTextStyle;

  /// Item touch callback.
  final IndexBarTouchCallback onTouch;

  @override
  _SuspensionListViewIndexBarState createState() =>
      _SuspensionListViewIndexBarState();
}

class _SuspensionListViewIndexBarState extends State<IndexBar> {
  bool _isTouchDown = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('吴娟傻逼 ----- ${widget.ignoreTags}');
  }

  @override
  Widget build(BuildContext context) {
    print('吴娟傻逼====== ${widget.tag}');
    return Container(
      alignment: Alignment.center,
      color: widget.color,
      width: widget.width.toDouble(),
      child: _IndexBar(
        tag: widget.tag,
        ignoreTags: widget.ignoreTags,
        data: widget.data,
        width: widget.width,
        itemHeight: widget.itemHeight,
        textStyle: widget.textStyle,
        touchDownTextStyle: widget.touchDownTextStyle,
        onTouch: (details) {
          if (widget.onTouch != null) {
            if (_isTouchDown != details.isTouchDown) {
              setState(() {
                _isTouchDown = details.isTouchDown;
              });
            }
            widget.onTouch(details);
          }
        },
      ),
    );
  }
}

/// Base IndexBar.
class _IndexBar extends StatefulWidget {
  /// index data.
  final List<String> data;

  final String tag;

  /// 忽略的Tags，这些忽略Tag, 不会高亮显示，点击或长按 不会弹出 tagHint
  final List<String> ignoreTags;

  /// IndexBar width(def:30).
  final int width;

  /// IndexBar item height(def:16).
  final int itemHeight;

  /// IndexBar text style.
  final TextStyle textStyle;

  final TextStyle touchDownTextStyle;

  /// Item touch callback.
  final IndexBarTouchCallback onTouch;

  _IndexBar(
      {Key key,
      this.data = INDEX_DATA_DEF,
      this.tag = '',
      this.ignoreTags = const [],
      @required this.onTouch,
      this.width = 30,
      this.itemHeight = 16,
      this.textStyle,
      this.touchDownTextStyle})
      : assert(onTouch != null),
        super(key: key);

  @override
  _IndexBarState createState() => _IndexBarState();
}

class _IndexBarState extends State<_IndexBar> {
  List<int> _indexSectionList = new List();
  int _widgetTop = -1;
  int _lastIndex = 0;
  bool _widgetTopChange = false;
  bool _isTouchDown = false;
  IndexBarDetails _indexModel = new IndexBarDetails();

  /// get index.
  int _getIndex(int offset) {
    for (int i = 0, length = _indexSectionList.length; i < length - 1; i++) {
      int a = _indexSectionList[i];
      int b = _indexSectionList[i + 1];
      if (offset >= a && offset < b) {
        return i;
      }
    }
    return -1;
  }

  void _init() {
    _widgetTopChange = true;
    _indexSectionList.clear();
    _indexSectionList.add(0);
    int tempHeight = 0;
    widget.data?.forEach((value) {
      tempHeight = tempHeight + widget.itemHeight;
      _indexSectionList.add(tempHeight);
    });
  }

  _triggerTouchEvent() {
    if (widget.onTouch != null) {
      widget.onTouch(_indexModel);
    }
  }

  // 获取背景色
  Color _fetchColor(String v) {
    if (_indexModel.tag == v) {
      final List<String> ignoreTags = widget.ignoreTags ?? [];
      return ignoreTags.indexOf(v) != -1
          ? Colors.transparent
          : Color(0xFF07C160);
    }
    return Colors.transparent;
  }

  // 获取文字颜色
  Color _fetchTextColor(String v) {
    if (_indexModel.tag == v) {
      final List<String> ignoreTags = widget.ignoreTags ?? [];
      return ignoreTags.indexOf(v) != -1 ? Colors.black : Colors.white;
    }
    return Colors.black;
  }

  // 获取Offstage
  bool _fetchOffstageColor(String v) {
    if (_indexModel.tag == v) {
      final List<String> ignoreTags = widget.ignoreTags ?? [];
      return ignoreTags.indexOf(v) != -1 ? true : !_indexModel.isTouchDown;
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('🔥火🔥 ------ ');
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _style = widget.textStyle;
    if (_indexModel.isTouchDown == true) {
      _style = widget.touchDownTextStyle;
    }
    _init();

    print('🔥火🔥 =======${widget.tag} ${_indexModel.tag}');
    // 配置 _indexModel tag 可能是用户滚动列表的数据 导致tag
    if (widget.tag != null &&
        widget.tag.isNotEmpty &&
        widget.tag != _indexModel.tag) {
      _indexModel.tag = widget.tag;
      _indexModel.isTouchDown = false;
      _indexModel.position = widget.data.indexOf(widget.tag);
    }

    // 部件数据源
    List<Widget> children = new List();

    widget.data.forEach((v) {
      children.add(new Container(
        width: widget.width.toDouble(),
        height: widget.itemHeight.toDouble(),
        alignment: Alignment.center,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _fetchColor(v),
                borderRadius: BorderRadius.circular(7),
              ),
              child: new Text(v,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10.0, color: _fetchTextColor(v))),
              width: 14.0,
              height: 14.0,
            ),
            Positioned(
              left: -80.0,
              top: -17.0,
              child: Offstage(
                offstage: _fetchOffstageColor(v),
                child: Container(
                  width: 60.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/ContactIndexShape_60x50.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  alignment: Alignment(-0.25, 0.0),
                  child: Text(
                    v,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
    });

    return GestureDetector(
      onVerticalDragDown: (DragDownDetails details) {
        if (_widgetTop == -1 || _widgetTopChange) {
          _widgetTopChange = false;
          RenderBox box = context.findRenderObject();
          Offset topLeftPosition = box.localToGlobal(Offset.zero);
          _widgetTop = topLeftPosition.dy.toInt();
        }
        int offset = details.globalPosition.dy.toInt() - _widgetTop;
        int index = _getIndex(offset);
        if (index != -1) {
          _lastIndex = index;
          _indexModel.position = index;
          _indexModel.tag = widget.data[index];
          _indexModel.isTouchDown = true;
          _triggerTouchEvent();
        }
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        int offset = details.globalPosition.dy.toInt() - _widgetTop;
        int index = _getIndex(offset);
        if (index != -1 && _lastIndex != index) {
          _lastIndex = index;
          _indexModel.position = index;
          _indexModel.tag = widget.data[index];
          _indexModel.isTouchDown = true;
          _triggerTouchEvent();
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        _indexModel.isTouchDown = false;
        _triggerTouchEvent();
      },
      onTapUp: (TapUpDetails details) {
        _indexModel.isTouchDown = false;
        _triggerTouchEvent();
      },
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
