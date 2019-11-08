import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';
import 'package:flutter_wechat/model/user/user.dart';

class ContactInfoHeader extends StatelessWidget {
  const ContactInfoHeader({
    Key key,
    @required this.user,
  }) : super(key: key);

  /// 用户信息
  final User user;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildChildWidget(),
    );
  }

  /// 构建子部件
  Widget _buildChildWidget() {
    Widget leading = Padding(
      padding: EdgeInsets.only(right: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: CachedNetworkImage(
          imageUrl: user.profileImageUrl,
          width: 66,
          height: 66,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return Image.asset(
              Constant.assetsImagesDefault + 'DefaultHead_48x48.png',
              width: 66.0,
              height: 66.0,
            );
          },
          errorWidget: (context, url, error) {
            return Image.asset(
              Constant.assetsImagesDefault + 'DefaultHead_48x48.png',
              width: 66.0,
              height: 66.0,
            );
          },
        ),
      ),
    );

    Widget middle = Padding(
      padding: EdgeInsets.only(right: Constant.pEdgeInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                user.screenName,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Style.pTextColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 6.0),
              Image.asset(
                Constant.assetsImagesContacts +
                    (user.gender == 0
                        ? "Contact_Male_18x18.png"
                        : "Contact_Female_18x18.png"),
                width: 18.0,
                height: 18.0,
              ),
            ],
          ),
          SizedBox(height: 3.0),
          Text(
            '昵称：${user.remarks}',
            style: TextStyle(fontSize: 12.0, color: Style.mTextColor),
          ),
          Text(
            '微信号：${user.wechatId}',
            style: TextStyle(fontSize: 12.0, color: Style.mTextColor),
          ),
          Offstage(
            offstage: Util.isEmptyString(user.region),
            child: Text(
              '地区：${user.region}',
              style: TextStyle(fontSize: 12.0, color: Style.mTextColor),
            ),
          ),
        ],
      ),
    );

    return MHListTile(
      contentPadding: EdgeInsets.fromLTRB(
          Constant.pEdgeInset, Constant.pEdgeInset, Constant.pEdgeInset, 20.0),
      leading: leading,
      middle: middle,
      dividerIndent: Constant.pEdgeInset,
      allowTap: false,
    );
  }
}
