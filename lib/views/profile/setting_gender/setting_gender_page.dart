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
class SettingGenderPage extends StatefulWidget {
  SettingGenderPage({Key key, @required this.value}) : super(key: key);

  /// value
  final String value;

  _SettingGenderPageState createState() => _SettingGenderPageState();
}

class _SettingGenderPageState extends State<SettingGenderPage> {
  /// 数据源
  List<CommonGroup> dataSource = [];

  /// 选中的Item
  CommonRadioItem _selectedItem;

  @override
  void initState() {
    super.initState();
    // 配置数据源
    _configData();
  }

  /// 配置数据
  void _configData() {
    // group0
    // 男
    final male = CommonRadioItem(
      title: '男',
      onTap: _itemOnTap,
      value: '男' == widget.value,
    );
    // 女
    final female = CommonRadioItem(
      title: '女',
      onTap: _itemOnTap,
      value: '女' == widget.value,
    );

    // 赋值给 _selectedItem
    _selectedItem = male.value ? male : female;

    final group0 = CommonGroup(
      items: [male, female],
    );

    // 添加数据源
    dataSource = [group0];
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
    return Container(
      child: ListView.builder(
        itemCount: dataSource.length,
        itemBuilder: (BuildContext context, int index) {
          return CommonGroupWidget(
            group: dataSource[index],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置性别'),
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
            padding: EdgeInsets.symmetric(horizontal: 16.0),
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
