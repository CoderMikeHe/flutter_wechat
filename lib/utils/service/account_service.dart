import 'package:flustars/flustars.dart';
import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flutter_wechat/model/user/user.dart';
export 'package:flutter_wechat/model/user/user.dart';

/// 处理账号登陆相关的问题
class AccountService {
  // 如果一个函数的构造方法并不总是返回一个新的对象的时候，可以使用factory，
  // 比如从缓存中获取一个实例并返回或者返回一个子类型的实例

  // 工厂方法构造函数
  factory AccountService() => _getInstance();

  // instance的getter方法，通过AccountService.instance获取对象
  static AccountService get sharedInstance => _getInstance();

  // 静态变量_instance，存储唯一对象
  static AccountService _instance;

  // 私有的命名式构造方法，通过它可以实现一个类可以有多个构造函数，
  // 子类不能继承internal不是关键字，可定义其他名字
  AccountService._internal() {
    // 初始化
    _initAsync();
  }

  // 获取对象
  static AccountService _getInstance() {
    if (_instance == null) {
      // 使用私有的构造方法来创建对象
      _instance = new AccountService._internal();
    }
    return _instance;
  }

  /// 异步初始化
  Future _initAsync() async {
    await SpUtil.getInstance();
    _user = SpUtil.getObj(CacheKey.wechatUserDataKey, (m) => User.fromJson(m));
  }

  /// 当前登陆的User
  User _user;
  User get currentUser {
    if (_user == null) {
      _user =
          SpUtil.getObj(CacheKey.wechatUserDataKey, (m) => User.fromJson(m));
    }
    return _user;
  }

  /// 用户登陆
  ///
  /// * [user] 登陆用户的信息
  /// * [rawLogin] 当前登陆账号
  void loginUser(User user, {String rawLogin = ''}) {
    // 存储登陆账号
    _rawLogin = rawLogin ?? '';
    SpUtil.putString(CacheKey.rawLoginKey, rawLogin);

    // 存储用户数据
    _user = user;
    SpUtil.putObject(CacheKey.wechatUserDataKey, user);
  }

  /// 退出登录
  void logoutUser() {
    // 清除账号信息
    _rawLogin = '';
    SpUtil.remove(CacheKey.rawLoginKey);

    // 清除用户信息 只内存中清除
    _user = null;
    // Fixed Bug： 退出登录，不要清除磁盘上的用户数据
    // SpUtil.remove(CacheKey.wechatUserDataKey);
  }

  /// 登陆账号信息
  String _rawLogin;
  String get rawLogin {
    if (_rawLogin == null) {
      _rawLogin = SpUtil.getString(CacheKey.rawLoginKey);
    }
    return _rawLogin;
  }
}

// Flutter 单例模式
// - https://juejin.im/post/5c83d5ac5188257de66337a9
// - https://blog.csdn.net/weixin_33720078/article/details/88730843
// - https://www.jianshu.com/p/563e662c9ce0
