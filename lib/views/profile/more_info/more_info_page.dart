import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_wechat/constant/cache_key.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';
import 'package:flutter_wechat/model/common/common_header.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

import 'package:flutter_wechat/views/profile/setting_gender/setting_gender_page.dart';
import 'package:flutter_wechat/views/profile/signature/signature_page.dart';

/// 账号与安全
class MoreInfoPage extends StatefulWidget {
  MoreInfoPage({Key key}) : super(key: key);

  _MoreInfoPageState createState() => _MoreInfoPageState();
}

class _MoreInfoPageState extends State<MoreInfoPage> {
  /// 数据源
  List<CommonGroup> _dataSource = [];

  @override
  void initState() {
    super.initState();

    // 配置数据源
    _configData();
  }

  /// 配置数据
  _configData() {
    // group0
    // 性别
    final gender = CommonItem(
      title: "性别",
      subtitle: '男',
      onTap: (item) async {
        final String result = await Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (_) {
              return SettingGenderPage(
                value: item.subtitle.isEmpty ? '男' : item.subtitle,
              );
            },
          ),
        );
        if (null != result && item.subtitle != result) {
          setState(() {
            item.subtitle = result;
          });
        }
      },
    );
    // 地址
    final address = CommonItem(
      title: "地址",
      subtitle: '广东 深圳',
      onTap: (_) {
        // Navigator.of(context).push(new MaterialPageRoute(
        //   builder: (_) {
        //     return BindingMailboxPage();
        //   },
        // ));
      },
    );
    // 签名
    final sign = CommonItem(
      title: "个性签名",
      subtitle: '生死看淡，不服就干',
      onTap: (item) async {
        final String result =
            await Navigator.of(context).push(new MaterialPageRoute(
          builder: (_) {
            return SignaturePage(
              text: (item.subtitle != null &&
                      item.subtitle.isNotEmpty &&
                      item.subtitle != '未填写')
                  ? item.subtitle
                  : '',
            );
          },
        ));
        // 取消，不做处理
        if (result != null && item.subtitle != result) {
          setState(() {
            item.subtitle =
                (result != null && result.isNotEmpty) ? result : '未填写';
          });
        }
      },
    );
    final group0 = CommonGroup(
      items: [
        gender,
        address,
        sign,
      ],
    );

    // 添加数据源
    _dataSource = [group0];
  }

  // 构建 child 的小部件
  Widget _buildChildWidget(BuildContext context) {
    return Container(
        child: ListView.builder(
      itemCount: _dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        return CommonGroupWidget(
          group: _dataSource[index],
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        child: _buildChildWidget(context),
      ),
    );
  }
}
