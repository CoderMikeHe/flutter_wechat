import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/components/photo_browser/photo_browser_router.dart';

import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';
import 'package:flutter_wechat/model/picture/picture.dart';
import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/components/photo_browser/photo.dart';

class ContactInfoMoments extends StatelessWidget {
  ContactInfoMoments({
    Key key,
    @required this.user,
  }) : super(key: key);

  /// 用户信息
  final User user;

  /// photos
  final List<Photo> _photos = new List();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          // 头部信息
          _buildheaderWidget(context),
          // 构建内容
          _buildContentWidget(context),
          // 分割线
          Divider(
            color: const Color(0xFFD8D8D8),
            indent: Constant.pEdgeInset,
            height: 0.5,
          ),
        ],
      ),
    );
  }

  // 打开图片浏览器
  void _openPhotoBrowser(BuildContext context, final int index) {
    // 先将photos 装成字符串
    final String jsonStr = jsonEncode(_photos);
    // 跳转
    NavigatorUtils.push(context,
        '${PhotoBrowserRouter.photoBrowserPage}?initialIndex=$index&photos=${Uri.encodeComponent(jsonStr)}',
        transition: TransitionType.fadeIn);
  }

  /// 构建子部件
  Widget _buildheaderWidget(BuildContext context) {
    Widget middle = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: ScreenUtil().setWidth(150.0),
      ),
      child: Text(
        '朋友圈',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(48.0), color: Style.pTextColor),
      ),
    );

    Widget trailing = Image.asset(
      Constant.assetsImagesArrow + 'tableview_arrow_8x13.png',
      width: ScreenUtil().setWidth(24.0),
      height: ScreenUtil().setHeight(39.0),
    );

    return MHListTile(
      contentPadding: EdgeInsets.all(Constant.pEdgeInset),
      allowTap: false,
      middle: middle,
      trailing: trailing,
      dividerIndent: ScreenUtil().setWidth(Constant.pEdgeInset * 3.0),
      dividerHeight: 0,
    );
  }

  Widget _buildContentWidget(BuildContext context) {
    // 计算朋友圈图片的大小
    // 获取屏幕的物理尺寸宽度
    final double screenW = ScreenUtil.screenWidthDp;
    // 5个数据
    final int count = 5;
    // 计算父部件的宽度
    final double momentsW = screenW -
        2 * Constant.pEdgeInset -
        ScreenUtil().setWidth(24.0) * (count - 1);

    // 就算图片的大小
    final double imageWH = momentsW / count;

    final List<Widget> children = [];
    if (user.pictures != null && user.pictures.length != 0) {
      final count = user.pictures.length;
      for (var i = 0; i < count; i++) {
        final Picture picture = user.pictures[i];

        final Photo photo = Photo(url: picture.big.url, tag: i.toString());
        _photos.add(photo);
        Widget w = InkWell(
          onTap: () {
            _openPhotoBrowser(context, i);
          },
          child: Hero(
            tag: i.toString(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30.0)),
              child: CachedNetworkImage(
                imageUrl: picture.small.url,
                width: imageWH,
                height: imageWH,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Image.asset(
                    Constant.assetsImagesDefault +
                        'ChatBackgroundThumb_00_100x100.png',
                    width: imageWH,
                    height: imageWH,
                  );
                },
                errorWidget: (context, url, error) {
                  return Image.asset(
                    Constant.assetsImagesDefault +
                        'ChatBackgroundThumb_00_100x100.png',
                    width: imageWH,
                    height: imageWH,
                  );
                },
              ),
            ),
          ),
        );
        children.add(w);
      }
    }
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(Constant.pEdgeInset * 3.0),
        right: ScreenUtil().setWidth(Constant.pEdgeInset * 3.0),
        bottom: ScreenUtil().setHeight(Constant.pEdgeInset * 3.0),
      ),
      child: Wrap(
        spacing: ScreenUtil().setWidth(24.0),
        runSpacing: ScreenUtil().setWidth(24.0),
        children: children,
      ),
    );
  }
}
