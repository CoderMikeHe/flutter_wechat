import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluro/fluro.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/components/photo_browser/photo_browser_router.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';
import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/components/photo_browser/photo.dart';

// 适配完毕
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
      child: _buildChildWidget(context),
    );
  }

  // 打开图片浏览器
  void _openPhotoBrowser(BuildContext context, final int index) {
    // 由于没有高清头像地址 这里用pictures.lastObj 作为高清图
    String url = '';
    if (this.user.pictures != null && this.user.pictures.length != 0) {
      url = this.user.pictures[this.user.pictures.length - 1].big.url;
    } else {
      url = this.user.profileImageUrl;
    }

    // 先将photos 装成字符串
    final String jsonStr = jsonEncode([Photo(url: url, tag: 'avatar')]);
    // 跳转
    NavigatorUtils.push(context,
        '${PhotoBrowserRouter.photoBrowserPage}?initialIndex=$index&photos=${Uri.encodeComponent(jsonStr)}',
        transition: TransitionType.fadeIn);
  }

  /// 构建子部件
  Widget _buildChildWidget(BuildContext context) {
    // 头像大小
    final double avatarWH = ScreenUtil().setWidth(192.0);
    Widget leading = Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(9.0), right: ScreenUtil().setWidth(60.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30.0)),
        child: InkWell(
          onTap: () {
            _openPhotoBrowser(context, 0);
          },
          child: Hero(
            tag: 'avatar',
            child: CachedNetworkImage(
              imageUrl: user.profileImageUrl,
              width: avatarWH,
              height: avatarWH,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Image.asset(
                  Constant.assetsImagesDefault + 'DefaultHead_48x48.png',
                  width: avatarWH,
                  height: avatarWH,
                );
              },
              errorWidget: (context, url, error) {
                return Image.asset(
                  Constant.assetsImagesDefault + 'DefaultHead_48x48.png',
                  width: avatarWH,
                  height: avatarWH,
                );
              },
            ),
          ),
        ),
      ),
    );

    Widget middle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //  CMH TODO: 这里应该是富文本
        Row(
          children: <Widget>[
            Text(
              user.screenName,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(60.0),
                  color: Style.pTextColor,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(width: ScreenUtil().setWidth(30.0)),
            Image.asset(
              Constant.assetsImagesContacts +
                  (user.gender == 0
                      ? "Contact_Male_18x18.png"
                      : "Contact_Female_18x18.png"),
              width: ScreenUtil().setWidth(56.0),
              height: ScreenUtil().setWidth(56.0),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(9.0)),
        Text(
          '昵称：${user.remarks}',
          style: TextStyle(
              fontSize: ScreenUtil().setSp(45.0), color: Color(0xFF808080)),
        ),
        Text(
          '微信号：${user.wechatId}',
          style: TextStyle(
              fontSize: ScreenUtil().setSp(45.0), color: Color(0xFF808080)),
        ),
        Offstage(
          offstage: Util.isEmptyString(user.region),
          child: Text(
            '地区：${user.region}',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(45.0), color: Color(0xFF808080)),
          ),
        ),
      ],
    );

    return MHListTile(
      contentPadding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(72.0),
        ScreenUtil().setHeight(15.0),
        ScreenUtil().setWidth(Constant.pEdgeInset * 3.0),
        ScreenUtil().setHeight(102.0),
      ),
      leading: leading,
      middle: middle,
      dividerIndent: ScreenUtil().setWidth(Constant.pEdgeInset * 3.0),
      allowTap: false,
    );
  }
}
