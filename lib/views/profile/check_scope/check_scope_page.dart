import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';
import 'package:flutter_wechat/model/common/common_header.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

/// 允许朋友查看朋友圈的范围
class CheckScopePage extends StatefulWidget {
  CheckScopePage({Key key, @required this.value}) : super(key: key);

  /// value
  final String value;

  _CheckScopePageState createState() => _CheckScopePageState();
}

class _CheckScopePageState extends State<CheckScopePage> {
  /// 数据源
  List<CommonGroup> dataSource = [];

  /// 选中的Item
  CommonRadioItem _selectedItem;

  /// 取消按钮颜色
  Color _cancelBtnTextColor = Color.fromRGBO(0, 0, 0, 0.9);

  @override
  void initState() {
    super.initState();
    // 配置数据源
    _configData();
  }

  /// 配置数据
  void _configData() {
    // group0
    // 最近三天
    final laterThreeDay = CommonRadioItem(
      title: '最近三天',
      onTap: _itemOnTap,
      value: '最近三天' == widget.value,
    );
    // 最近一个月
    final laterMonth = CommonRadioItem(
      title: '最近一个月',
      onTap: _itemOnTap,
      value: '最近一个月' == widget.value,
    );
    // 最近半年
    final laterHalfYear = CommonRadioItem(
      title: '最近半年',
      onTap: _itemOnTap,
      value: '最近半年' == widget.value,
    );
    // 全部
    final laterAll = CommonRadioItem(
      title: '全部',
      value: '全部' == widget.value,
      onTap: _itemOnTap,
    );

    // 赋值给 _selectedItem
    _selectedItem = laterThreeDay.value
        ? laterThreeDay
        : (laterMonth.value
            ? laterMonth
            : (laterHalfYear.value ? laterHalfYear : laterAll));

    final group0 = CommonGroup(
      items: [laterThreeDay, laterMonth, laterHalfYear, laterAll],
      footer: CommonFooter(footer: '在选择的事件范围之前发布的朋友圈，将对朋友不可见'),
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
        title: Text('允许朋友查看朋友圈的范围'),
        // leading : 最大宽度为56.0
        leading: Container(
          padding: EdgeInsets.only(left: 16.0),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).maybePop();
                },
                onHighlightChanged: (bool val) {
                  setState(() {
                    _cancelBtnTextColor =
                        Color.fromRGBO(0, 0, 0, val ? 0.5 : 0.9);
                  });
                },
                child: Text(
                  '取消',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: _cancelBtnTextColor,
                  ),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                RaisedButton(
                  textTheme: ButtonTextTheme.accent,
                  onPressed: () {
                    Navigator.of(context).pop(_selectedItem.title);
                  },
                  color: Color(0xFF07C160),
                  highlightColor: Color(0xFF06AD56),
                  textColor: Colors.white,
                  child: Text(
                    '完成',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                )
              ],
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
