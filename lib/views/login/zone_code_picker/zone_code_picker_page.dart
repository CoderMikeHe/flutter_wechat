import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/model/zone_code/zone_code.dart';
import 'package:flutter_wechat/utils/service/zone_code_service.dart';

import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';
import 'package:flutter_wechat/components/search_bar/search_bar.dart';

class ZoneCodePickerPage extends StatefulWidget {
  ZoneCodePickerPage({Key key, @required this.value}) : super(key: key);

  /// value
  final String value;

  /// 构建部件
  _ZoneCodePickerPageState createState() => _ZoneCodePickerPageState();
}

class _ZoneCodePickerPageState extends State<ZoneCodePickerPage> {
  /// 联系人列表
  List<ZoneCode> _zoneCodeList = [];
  int _suspensionHeight = 36;
  int _itemHeight = 44;
  String _suspensionTag = "";

  @override
  void initState() {
    super.initState();
    // 请求联系人
    _fetchZoneCode();
  }

  /// 请求联系人列表
  void _fetchZoneCode() async {
    List<ZoneCode> list = [];
    if (ZoneCodeService.sharedInstance.zoneCodeList != null &&
        ZoneCodeService.sharedInstance.zoneCodeList.isNotEmpty) {
      list = ZoneCodeService.sharedInstance.zoneCodeList;
    } else {
      list = await ZoneCodeService.sharedInstance.fetchZoneCode();
    }
    setState(() {
      _zoneCodeList = list;
    });
  }

  /// 索引标签被点击
  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  /// 构建头部
  Widget _buildHeader() {
    return Column(
      children: <Widget>[SearchBar()],
    );
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  Widget _buildListItem(ZoneCode zoneCode) {
    String susTag = zoneCode.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: zoneCode.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        Container(
          height: _itemHeight.toDouble(),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildItem(zoneCode.name, zoneCode.tel, onTap: () {
                  Navigator.of(context).pop(zoneCode.tel);
                }),
              )
            ],
          ),
        ),
      ],
    );
  }

  /// 返回 item
  Widget _buildItem(
    String title,
    String telCode, {
    void Function() onTap,
  }) {
    Widget middle = Padding(
      padding: EdgeInsets.only(right: Constant.pEdgeInset),
      child: Text(
        title,
        style: TextStyle(fontSize: 16.0, color: Style.pTextColor),
      ),
    );
    Widget trailing = Padding(
      padding: EdgeInsets.only(right: Constant.pEdgeInset * 2),
      child: Text(
        '+$telCode',
        style: TextStyle(fontSize: 16.0, color: Style.sTextColor),
      ),
    );
    return MHListTile(
      onTap: onTap,
      middle: middle,
      trailing: trailing,
      height: _itemHeight.toDouble(),
      dividerIndent: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择国家和地区'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: AzListView(
                data: _zoneCodeList,
                itemBuilder: (context, model) => _buildListItem(model),
                suspensionWidget: _buildSusWidget(_suspensionTag),
                isUseRealIndex: true,
                itemHeight: _itemHeight,
                suspensionHeight: _suspensionHeight,
                onSusTagChanged: _onSusTagChanged,
                header: AzListViewHeader(
                    // - [特殊字符](https://blog.csdn.net/cfxy666/article/details/87609526)
                    // - [特殊字符](http://www.fhdq.net/)
                    tag: "♀",
                    height: 56,
                    builder: (context) {
                      return _buildHeader();
                    }),
                indexHintBuilder: (context, hint) {
                  return Container(
                    alignment: Alignment.center,
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Text(hint,
                        style: TextStyle(color: Colors.white, fontSize: 30.0)),
                  );
                },
              )),
        ],
      ),
    );
  }
}
