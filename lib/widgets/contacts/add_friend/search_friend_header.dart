import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

class SearchFriendHeader extends StatelessWidget {
  const SearchFriendHeader({
    Key key,
    this.onTapSearchBar,
    this.onTapQrCode,
  }) : super(key: key);

  /// 点击searchBar
  final GestureTapCallback onTapSearchBar;

  /// 点击二维码
  final GestureTapCallback onTapQrCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Style.pBackgroundColor,
      child: Column(
        children: <Widget>[
          _buildSearchBarWidget(context),
          _buildQrCodeWidget(context),
        ],
      ),
    );
  }

  /// 构建searchbar部件
  Widget _buildSearchBarWidget(BuildContext context) {
    return InkWell(
      child: Container(
        height: 44.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 16.0,
            ),
            Image.asset(
              Constant.assetsImagesContacts + 'add_friend_searchicon_36x30.png',
              width: 36.0,
              height: 30.0,
            ),
            Text(
              '搜索',
              style: TextStyle(
                color: Style.sTextColor,
              ),
            )
          ],
        ),
      ),
      onTap: onTapSearchBar,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }

  /// 构建微信号小部件
  Widget _buildQrCodeWidget(BuildContext context) {
    return Container(
      color: Style.pBackgroundColor,
      padding: EdgeInsets.only(top: 6.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('我的微信号：luangangsanqian'),
          SizedBox(width: 6.0),
          InkWell(
            child: Image.asset(
              Constant.assetsImagesContacts + 'add_friend_myQR_20x20.png',
              width: 20.0,
              height: 20.0,
            ),
            onTap: onTapQrCode,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
