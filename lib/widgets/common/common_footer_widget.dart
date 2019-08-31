import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';

import 'package:flutter_wechat/model/common/common_footer.dart';

class CommonFooterWidget extends StatelessWidget {
  const CommonFooterWidget({Key key, this.footer}) : super(key: key);
  final CommonFooter footer;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          Constant.pEdgeInset, 4.0, Constant.pEdgeInset, Constant.pEdgeInset),
      child: _buildChildWidget(),
    );
  }

  /// 生成child小部件
  Widget _buildChildWidget() {
    if (footer is CommonFooter) {
      return _buildCommonFooter(footer);
    }
    return null;
  }

  /// 生成 common header
  Widget _buildCommonFooter(CommonFooter footer) {
    return Container(
      width: double.maxFinite,
      child: Text(
        footer.footer,
        style: TextStyle(color: Color(0xFF888888), fontSize: 14.5),
      ),
    );
  }
}
