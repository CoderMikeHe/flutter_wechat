import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key key, this.onTapTitle, this.onTapContent})
      : super(key: key);

  /// 点击名称
  final VoidCallback onTapTitle;

  /// 点击内容
  final VoidCallback onTapContent;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(bottom: 40.0, top: 72.0),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Constant.pEdgeInset),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              InkWell(
                child: CachedNetworkImage(
                  imageUrl:
                      'http://tva3.sinaimg.cn/crop.0.6.264.264.180/93276e1fjw8f5c6ob1pmpj207g07jaa5.jpg',
                  placeholder: (context, url) {
                    return Image.asset(
                      'assets/images/DefaultProfileHead_66x66.png',
                      width: 66.0,
                      height: 66.0,
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      'assets/images/DefaultProfileHead_66x66.png',
                      width: 66.0,
                      height: 66.0,
                    );
                  },
                  width: 66.0,
                  height: 66.0,
                ),
                onTap: onTapContent,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: onTapTitle,
                        child: Container(
                          width: double.maxFinite,
                          child: Text(
                            '微信-乱港三千-Mr_元先森',
                            style: TextStyle(
                              color: Style.pTextColor,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onTapContent,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '微信号：codermikehe',
                                  style: TextStyle(
                                    color: Style.pTextColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 13.0),
                                child: Image.asset(
                                  Constant.assetsImages +
                                      'setting_myQR_36x36.png',
                                  width: 18.0,
                                  height: 18.0,
                                ),
                              ),
                              Image.asset(
                                Constant.assetsImagesArrow +
                                    'tableview_arrow_8x13.png',
                                width: 8.0,
                                height: 13.0,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
