import 'package:flutter/material.dart';

import 'package:flustars/flustars.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'
    as FlutterScreenUtil;
import 'package:package_info/package_info.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:flutter_wechat/utils/util.dart';
import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/views/login/login_router.dart';
import 'package:flutter_wechat/routers/routers.dart';

import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flutter_wechat/constant/constant.dart';

import 'package:flutter_wechat/utils/service/account_service.dart';
import 'package:flutter_wechat/utils/service/contacts_service.dart';
import 'package:flutter_wechat/utils/service/zone_code_service.dart';

// 适配完毕
/// 闪屏跳转模式
enum MHSplashSkipMode {
  newFeature, // 新特性（引导页）
  login, // 登陆
  currentLogin, // 账号登陆
  homePage, // 主页
  ad, // 广告页
}

/// 闪屏界面主要用来中转（新特性界面、登陆界面、主页面）
class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// 跳转方式
  MHSplashSkipMode _skipMode;

  /// 定时器相关
  TimerUtil _timerUtil;

  /// 计数
  int _count = 5;

  /// 点击是否高亮
  bool _highlight = false;

  @override
  void dispose() {
    super.dispose();
    // 记得中dispose里面把timer cancel。
    if (_timerUtil != null) _timerUtil.cancel();
  }

  @override
  void initState() {
    super.initState();
    // 监听部件渲染完
    /// widget渲染监听。
    WidgetUtil widgetUtil = new WidgetUtil();
    widgetUtil.asyncPrepares(true, (_) async {
      // widget渲染完成。
      // App启动时读取Sp数据，需要异步等待Sp初始化完成。必须保证它 优先初始化。
      await SpUtil.getInstance();

      // 获取一下通讯录数据，理论上是在跳转到主页时去请求
      ContactsService.sharedInstance;

      // 读取一下全球手机区号编码
      ZoneCodeService.sharedInstance;

      /// 获取App信息
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // String appName = packageInfo.appName;
      // String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      // 拼接app version
      final String appVersion = version + '+' + buildNumber;

      // 获取缓存的版本号
      final String cacheVersion = SpUtil.getString(CacheKey.appVersionKey);

      // 获取用户信息
      if (appVersion != cacheVersion) {
        // 保存版本
        SpUtil.putString(CacheKey.appVersionKey, appVersion);
        // 更新页面，切换为新特性页面
        setState(() {
          _skipMode = MHSplashSkipMode.newFeature;
        });
      } else {
        setState(() {
          _skipMode = MHSplashSkipMode.ad;
        });
        // 配置定时器
        _configureCountDown();
      }
    });
  }

  // 切换rootView
  void _switchRootView() {
    // 取出登陆账号
    final String rawLogin = AccountService.sharedInstance.rawLogin;
    // 取出用户
    final User currentUser = AccountService.sharedInstance.currentUser;
    // 跳转路径
    String skipPath;
    // 跳转模式
    MHSplashSkipMode skipMode;
    if (Util.isNotEmptyString(rawLogin) && currentUser != null) {
      // 有登陆账号 + 有用户数据 跳转到 主页
      skipMode = MHSplashSkipMode.homePage;
      skipPath = Routers.homePage;
    } else if (currentUser != null) {
      // 没有登陆账号 + 有用户数据 跳转到当前登陆
      skipMode = MHSplashSkipMode.currentLogin;
      skipPath = LoginRouter.currentLoginPage;
    } else {
      // 没有登陆账号 + 没有用户数据 跳转到登陆
      skipMode = MHSplashSkipMode.login;
      skipPath = LoginRouter.loginPage;
    }
    // 这里无需更新 页面 直接跳转即可
    _skipMode = skipMode;

    // 跳转对应的主页
    NavigatorUtils.push(context, skipPath,
        clearStack: true, transition: TransitionType.fadeIn);
  }

  /// 配置倒计时
  void _configureCountDown() {
    _timerUtil = TimerUtil(mTotalTime: 5000);
    _timerUtil.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      if (_tick == 0) {
        // 切换到主页面
        _switchRootView();
      } else {
        setState(() {
          _count = _tick.toInt();
        });
      }
    });
    _timerUtil.startCountDown();
  }

  @override
  Widget build(BuildContext context) {
    /// 配置屏幕适配的  flutter_screenutil 和  flustars 设计稿的宽度和高度(单位px)
    /// Set the fit size (fill in the screen size of the device in the design) If the design is based on the size of the iPhone6 ​​(iPhone6 ​​750*1334)
    // 配置设计图尺寸，iphone 7 plus 1242.0 x 2208.0
    final double designW = 1242.0;
    final double designH = 2208.0;

    FlutterScreenUtil.ScreenUtil.instance =
        FlutterScreenUtil.ScreenUtil(width: designW, height: designH)
          ..init(context);
    setDesignWHD(designW, designH, density: 3);

    /// If you use a dependent context-free method to obtain screen parameters and adaptions, you need to call this method.
    MediaQuery.of(context);
    Widget child;
    if (_skipMode == MHSplashSkipMode.newFeature) {
      // 引导页
      child = _buildNewFeatureWidget();
    } else if (_skipMode == MHSplashSkipMode.ad) {
      // 广告页
      child = _buildAdWidget();
    } else {
      // 启动页
      child = _buildDefaultLaunchImage();
    }
    return Material(child: child);
  }

  /// 默认情况是一个启动页 1200x530
  /// https://game.gtimg.cn/images/yxzj/img201606/heroimg/121/121-bigskin-4.jpg
  Widget _buildDefaultLaunchImage() {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        // 这里设置颜色 跟启动页一致的背景色，以免发生白屏闪烁
        color: Color.fromRGBO(0, 10, 24, 1),
        image: DecorationImage(
          // 注意：启动页 别搞太大 以免加载慢
          image: AssetImage(Constant.assetsImages + 'LaunchImage.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// 新特性界面
  Widget _buildNewFeatureWidget() {
    return Swiper(
      itemCount: 3,
      loop: false,
      itemBuilder: (_, index) {
        final String name =
            Constant.assetsImagesNewFeature + 'intro_page_${index + 1}.png';
        Widget widget = Image.asset(
          name,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
        if (index == 2) {
          return Stack(
            children: <Widget>[
              widget,
              Positioned(
                child: InkWell(
                  child: Image.asset(
                    Constant.assetsImagesNewFeature + 'skip_btn.png',
                    width: 175.0,
                    height: 55.0,
                  ),
                  onTap: _switchRootView,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                ),
                left: (ScreenUtil.getInstance().screenWidth - 175) * 0.5,
                bottom: 55.0,
                width: 175.0,
                height: 55.0,
              ),
            ],
          );
        } else {
          return widget;
        }
      },
    );
  }

  /// 广告页
  Widget _buildAdWidget() {
    return Container(
      child: _buildAdChildWidget(),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        // 这里设置颜色 跟背景一致的背景色，以免发生白屏闪烁
        color: Color.fromRGBO(21, 5, 27, 1),
        image: DecorationImage(
          image: AssetImage(Constant.assetsImagesBg + 'SkyBg01_320x490.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAdChildWidget() {
    final double horizontal =
        FlutterScreenUtil.ScreenUtil.getInstance().setWidth(30.0);
    final double vertical =
        FlutterScreenUtil.ScreenUtil.getInstance().setHeight(9.0);
    final double fontSize =
        FlutterScreenUtil.ScreenUtil.getInstance().setSp(42.0);
    final lineHeight =
        FlutterScreenUtil.ScreenUtil.getInstance().setHeight(20.0 * 3 / 14.0);
    final radius = FlutterScreenUtil.ScreenUtil.getInstance().setWidth(108.0);
    return Stack(
      children: <Widget>[
        Swiper(
          onTap: (idx) {
            // 跳转到Web
          },
          itemCount: 4,
          autoplayDelay: 1500,
          loop: true,
          autoplay: true,
          itemBuilder: (_, index) {
            return Center(
              child: Image.asset(
                Constant.assetsImagesAds + '121-bigskin-${index + 1}.jpg',
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        Positioned(
          top: FlutterScreenUtil.ScreenUtil.getInstance().setHeight(30.0) +
              FlutterScreenUtil.ScreenUtil.statusBarHeight,
          right: FlutterScreenUtil.ScreenUtil.getInstance().setWidth(60.0),
          child: InkWell(
            onTap: () {
              if (_timerUtil != null) {
                _timerUtil.cancel();
              }
              _switchRootView();
            },
            onHighlightChanged: (highlight) {
              setState(() {
                _highlight = highlight;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontal, vertical: vertical),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _highlight ? Colors.white30 : Colors.white10,
                border: Border.all(color: Colors.white, width: 0),
                borderRadius: BorderRadius.all(Radius.circular(radius)),
              ),
              child: Text(
                '跳过 $_count',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    height: lineHeight),
              ),
            ),
          ),
        )
      ],
    );
  }
}
