import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_wechat/constant/constant.dart';

class BouncyBalls extends StatelessWidget {
  const BouncyBalls({Key key, this.offset}) : super(key: key);

  // 偏移量
  final double offset;

  @override
  Widget build(BuildContext context) {
    // 阶段I临界点
    final double stage1Distance = 60;
    // 阶段II临界点
    final double stage2Distance = 90;
    // 阶段III临界点
    final double stage3Distance = 130;
    // 阶段IV临界点
    final double stage4Distance = 180;

    final screenW = ScreenUtil.screenWidthDp;
    final screenH = ScreenUtil.screenHeightDp;

    final top = (offset + 44 + 10 - 6) * 0.5;

    // 中间点相关
    double scale = 0.0;
    double opacityC = 0;

    // 右边点相关
    double translateR = 0.0;
    double opacityR = 0;

    // 右边点相关
    double translateL = 0.0;
    double opacityL = 0;

    if (offset > stage3Distance) {
      // 中间点阶段III: 保持scale 为1
      opacityC = 1;
      scale = 1;

      // 右边点阶段III: 平移到最右侧
      opacityR = 1;
      translateR = 16;

      // 左边点阶段III: 平移到最左侧
      opacityL = 1;
      translateL = -16;
    } else if (offset > stage2Distance) {
      final delta = stage3Distance - stage2Distance;
      final deltaOffset = offset - stage2Distance;

      // 中间点阶段II: 中间点缩小：2 -> 1
      final stepC = 1 / delta;
      opacityC = 1;
      scale = 2 - stepC * deltaOffset;

      // 右边点阶段II: 慢慢平移 0 -> 16
      final stepR = 16.0 / delta;
      opacityR = 1;
      translateR = stepR * deltaOffset;

      // 左边点阶段II: 慢慢平移 0 -> -16
      final stepL = -16.0 / delta;
      opacityL = 1;
      translateL = stepL * deltaOffset;
    } else if (offset > stage1Distance) {
      final delta = stage2Distance - stage1Distance;
      final deltaOffset = offset - stage1Distance;

      // 中间点阶段I: 中间点放大：0 -> 2
      final step = 2 / delta;
      opacityC = 1;
      scale = 0 + step * deltaOffset;
    }

    print('object $scale');

    return Container(
      height: offset,
      width: double.infinity,
      child: Stack(
        // 指定未定位或部分定位widget的对齐方式
        alignment: Alignment.center,
        children: <Widget>[
          // 左边球
          Positioned(
            top: top,
            child: Offstage(
              offstage: opacityL == 0,
              child: Transform.translate(
                offset: Offset(translateL, 0.0),
                child: _buildBallWidget(),
              ),
            ),
          ),
          // 右边球
          Positioned(
            top: top,
            child: Offstage(
              offstage: opacityR == 0,
              child: Transform.translate(
                offset: Offset(translateR, 0.0),
                child: _buildBallWidget(),
              ),
            ),
          ),
          // 中间球
          Positioned(
            top: top,
            child: Offstage(
              offstage: opacityC == 0,
              child: Transform.scale(
                scale: scale,
                child: _buildBallWidget(),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 生成一个球部件
  Widget _buildBallWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFb7b7b7),
        borderRadius: BorderRadius.circular(3),
      ),
      width: 6,
      height: 6,
    );
  }
}
