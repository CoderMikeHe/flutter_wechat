import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';

import 'package:flutter_wechat/model/common/common_header.dart';

class CommonHeaderWidget extends StatelessWidget {
  /// 构造函数
  const CommonHeaderWidget({Key key, this.header}) : super(key: key);

  /// header 对象
  final CommonHeader header;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          Constant.pEdgeInset, Constant.pEdgeInset, Constant.pEdgeInset, 4.0),
      child: _buildChildWidget(),
    );
  }

  /// 生成child小部件
  Widget _buildChildWidget() {
    if (header is CommonHeader) {
      return _buildCommonHeader(header);
    }
    return null;
  }

  /// 生成 common header
  Widget _buildCommonHeader(CommonHeader header) {
    return Container(
      width: double.maxFinite,
      child: Text(
        header.header,
        style: TextStyle(color: Color(0xFF888888), fontSize: 14.5),
      ),
    );
  }
}
