import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/components/app_bar/mh_app_bar.dart';
import 'package:flutter_wechat/widgets/discover/moments/moments_profile_widget.dart';

class MomentsPage extends StatefulWidget {
  MomentsPage({Key key}) : super(key: key);

  _MomentsPageState createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
  // AppBar transparent
  bool _appBarTransparent = true;

  /// ✨✨✨✨✨✨✨ Override ✨✨✨✨✨✨✨
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        child: _buildChildWidget(),
      ),
    );
  }

  /// ✨✨✨✨✨✨✨ UI ✨✨✨✨✨✨✨
  Widget _buildChildWidget() {
    return Stack(
      children: <Widget>[
        // 列表
        _buildContentWidget(),

        // 导航栏
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: _buildAppBarWidget(),
        )
      ],
    );
  }

  /// 构建内容页
  Widget _buildContentWidget() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: MomentsProfileWidget(),
        )
      ],
    );
  }

  /// 构建导航栏
  Widget _buildAppBarWidget() {
    final String iconName = _appBarTransparent
        ? 'icons_filled_camera.svg'
        : 'icons_outlined_camera.svg';

    final Color iconColor =
        _appBarTransparent ? Colors.white : Color(0xFF181818);

    final String title = _appBarTransparent ? '' : '朋友圈';

    final Color backgroundColor =
        _appBarTransparent ? Colors.transparent : Style.pBackgroundColor;

    final double elevation = _appBarTransparent ? 0 : 1.0;

    return MHAppBar(
      title: Text(title),

      /// 设置AppBar透明，必须设置为0
      elevation: elevation,
      backgroundColor: backgroundColor,
      leading: BackButton(color: iconColor),
      actions: <Widget>[
        IconButton(
          // icons_outlined_camera
          icon: new SvgPicture.asset(
            Constant.assetsImagesMoments + iconName,
            color: iconColor,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
