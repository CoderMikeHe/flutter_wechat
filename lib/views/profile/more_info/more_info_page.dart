import 'package:flutter/material.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/views/profile/profile_rourer.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

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
      onTap: (item) {
        final String value = item.subtitle.isEmpty ? '男' : item.subtitle;
        // 跳转
        NavigatorUtils.pushResult(
          context,
          '${ProfileRouter.settingGenderPage}?value=${Uri.encodeComponent(value)}',
          (result) {
            if (null != result && item.subtitle != result) {
              setState(() {
                item.subtitle = result;
              });
            }
          },
        );
      },
    );
    // 地址
    final address = CommonItem(
      title: "地址",
      subtitle: '广东 深圳',
      onTap: (_) {},
    );
    // 签名
    final sign = CommonItem(
      title: "个性签名",
      subtitle: '生死看淡，不服就干',
      onTap: (item) async {
        final String text = (item.subtitle != null &&
                item.subtitle.isNotEmpty &&
                item.subtitle != '未填写')
            ? item.subtitle
            : '';
        // 跳转
        NavigatorUtils.pushResult(
          context,
          '${ProfileRouter.signaturePage}?text=${Uri.encodeComponent(text)}',
          (result) {
            if (null != result && item.subtitle != result) {
              setState(() {
                item.subtitle =
                    (result != null && (result as String).isNotEmpty)
                        ? result
                        : '未填写';
              });
            }
          },
        );
      },
    );
    final group0 = CommonGroup(items: [gender, address, sign]);

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
