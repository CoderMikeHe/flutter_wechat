import 'package:flutter/material.dart';
import 'package:flutter_wechat/constant/style.dart';

class AboutUsFooter extends StatefulWidget {
  AboutUsFooter({Key key, this.height}) : super(key: key);

  /// 控件高度
  final double height;

  _AboutUsFooterState createState() => _AboutUsFooterState();
}

class _AboutUsFooterState extends State<AboutUsFooter> {
  /// 协议文字是否高亮
  bool _highlight0 = false;
  bool _highlight1 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: _buildChidWidget(),
    );
  }

  /// 构建子部件
  Widget _buildChidWidget() {
    return Stack(
      children: <Widget>[
        Positioned(
          child: _buildItemWidget(),
          bottom: 20,
          left: 16.0,
          right: 16.0,
        ),
      ],
    );
  }

  /// 构建内部部件
  Widget _buildItemWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          _buildAgreementWidget(),
          SizedBox(height: 15.0),
          Text(
            '腾讯公司 版权所有',
            style: TextStyle(
              color: Style.mTextColor,
              fontSize: 12.0,
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            'Copyright © 2011-2019 Tencent.All Rights Reserved.',
            style: TextStyle(
              color: Style.mTextColor,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建协议部件
  Widget _buildAgreementWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          child: Text(
            '《微信软件许可及服务协议》',
            style: TextStyle(
                color: Color(0xFF576b95),
                fontSize: 12.0,
                backgroundColor:
                    _highlight0 ? Color(0xFFc7c7c5) : Colors.transparent),
          ),
          onHighlightChanged: (highlight) {
            setState(() {
              _highlight0 = highlight;
            });
          },
          onTap: () {},
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
        ),
        Text(
          '和',
          style: TextStyle(
            color: Style.sTextColor,
            fontSize: 12.0,
          ),
        ),
        InkWell(
          child: Text(
            '《微信意思保护指引》',
            style: TextStyle(
                color: Color(0xFF576b95),
                fontSize: 12.0,
                backgroundColor:
                    _highlight1 ? Color(0xFFc7c7c5) : Colors.transparent),
          ),
          onHighlightChanged: (highlight) {
            setState(() {
              _highlight1 = highlight;
            });
          },
          onTap: () {},
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
        ),
      ],
    );
  }
}
