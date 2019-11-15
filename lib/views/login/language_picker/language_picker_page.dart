import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';
import 'package:flutter_wechat/model/common/common_header.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';
import 'package:flutter_wechat/widgets/bar_button/bar_button.dart';

/// 允许朋友查看朋友圈的范围
class LanguagePickerPage extends StatefulWidget {
  LanguagePickerPage({Key key, @required this.value}) : super(key: key);

  /// value
  final String value;

  _LanguagePickerPageState createState() => _LanguagePickerPageState();
}

class _LanguagePickerPageState extends State<LanguagePickerPage> {
  /// 数据源
  List dataSource = [];

  /// 选中的Item
  CommonRadioItem _selectedItem;

  @override
  void initState() {
    super.initState();
    // 配置数据源
    _configData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 配置数据
  void _configData() async {
    /// https://www.zybang.com/question/8b478510701184609e88eec8d869f87e.html 国家语言列表 拿走不谢
    final titles = [
      "简体中文",
      "繁體中文（台灣）",
      "繁體中文（香港）",
      "English",
      "Bahasa Indonesia",
      "Bahasa Melayu",
      "español",
      // Fixed Bug：这里如果显示了 韩语，会导致导航栏 文字显示异常，Why
      // "한국어",
      "Italiano",
      "日本語",
      "Polski",
      "Português",
      "Русский",
      "ภาษาไทย",
      "Tiếng Việt",
      "العربية",
      "हिन्दी",
      "עברית",
      "Türkçe",
      "Deutsch",
      "Français"
    ];

    // 赋值给 _selectedItem
    final List<CommonItem> items = [];
    final length = titles.length;
    for (var i = 0; i < length; i++) {
      final t = titles[i];
      CommonRadioItem item = CommonRadioItem(
        title: t,
        onTap: _itemOnTap,
        value: widget.value == t,
      );
      if (item.title == widget.value) {
        _selectedItem = item;
      }
      items.add(item);
    }
    final group0 = CommonGroup(
      items: items,
    );
    // 添加数据源
    setState(() {
      dataSource = [group0];
    });
  }

  /// itemOnTap
  void _itemOnTap(CommonItem i) {
    final CommonRadioItem item = (i as CommonRadioItem);
    // 三部曲
    if (_selectedItem == null) {
      setState(() {
        item.value = true;
        _selectedItem = item;
      });
    } else if (_selectedItem != null && _selectedItem == item) {
    } else if (_selectedItem != null && _selectedItem != item) {
      setState(() {
        _selectedItem.value = false;
        item.value = true;
      });
    }
    _selectedItem = item;
  }

  // 构建 child 的小部件
  Widget _buildChildWidget(BuildContext context) {
    return ListView.builder(
      itemCount: dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        return CommonGroupWidget(
          group: dataSource[index],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '设置性别',
          textAlign: TextAlign.center,
          textScaleFactor: 1.0,
        ),
        // leading : 最大宽度为56.0
        leading: Container(
            padding: EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            child: BarButton(
              '取消',
              textColor: Style.pTextColor,
              highlightTextColor: Style.sTextColor,
              onTap: () {
                Navigator.of(context).pop();
              },
            )),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 16.0),
            alignment: Alignment.centerRight,
            child: BarButton(
              '完成',
              textColor: Colors.white,
              highlightTextColor: Colors.white.withOpacity(0.5),
              disabledTextColor: Colors.white.withOpacity(0.3),
              color: Style.pTintColor,
              highlightColor: Style.sTintColor,
              disabledColor: Style.sTintColor.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              enabled: true,
              onTap: () {
                Navigator.of(context).pop(_selectedItem.title);
              },
            ),
          )
        ],
      ),
      body: Container(
        child: _buildChildWidget(context),
      ),
    );
  }
}
