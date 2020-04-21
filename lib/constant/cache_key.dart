import 'package:flutter/material.dart';

class CacheKey {
  /// 应用缓存的版本，主要用来判断新特性
  static const String appVersionKey = "app_version_key";

  /// 应用语言
  static const String appLanguageKey = "app_language_key";

  /// 登陆账号
  static const String rawLoginKey = "raw_login_key";

  /// 微信登陆账号信息
  static const String wechatUserDataKey = "wechat_user_data_key";

  /// ---- 通用
  /// 听筒模式
  static const String receiverModeKey = "receiver_mode_key";

  // 设置静态属性 本项目规定：大写的属性认为是静态属性且只读
  /// ---- 应用
  /// 第一次使用
  static const String initializedKey = "initialized_key";

  /// ---- 发现页key
  /// 朋友圈
  static const String momentsKey = "moments_key";

  /// 扫一扫
  static const String qrCodeKey = "qrCode_key";

  /// 摇一摇
  static const String shakeKey = "shake_key";

  /// 看一看
  static const String lookKey = "look_key";

  /// 搜一搜
  static const String searchKey = "search_key";

  /// 附近的人
  static const String locationServiceKey = "locationService_key";

  /// 漂流瓶
  static const String bottleKey = "bottle_key";

  /// 购物
  static const String shoppingKey = "shopping_key";

  /// 游戏
  static const String gameKey = "game_key";

  /// 小程序
  static const String moreAppsKey = "more_apps_key";

  /// ---- 新消息通知
  /// 新消息通知
  static const String messageNotifyKey = "message_notify_key";

  /// 语音和视频通话提醒
  static const String callReminderKey = "call_reminder_key";

  /// 通知显示消息详情
  static const String notifyMessageDetailKey = "notify_message_detail_key";

  /// 声音
  static const String notifyVoiceKey = "notify_voice_key";

  /// 振动
  static const String notifyVibrationKey = "notify_vibration_key";

  /// ---- 隐私
  /// 加我为朋友时需要验证
  static const String addFriendNeedVerifyKey = "add_friend_need_verify_key";

  /// 向我推荐通讯录朋友
  static const String recommendFriendFromContactsListKey =
      "recommend_friend_from_contacts_list_key";

  /// 允许陌生人查看十条朋友圈
  static const String allowStrongerWatchTenMomentsKey =
      "allow_stronger_watch_ten_moments_key";

  /// 朋友圈更新提醒
  static const String momentsUpdateAlertKey = "moments_update_alert_key";

  /// 朋友圈查看范围
  static const String momentsCheckScopeKey = "moments_check_scope_key";

  /// ---- 添加我的方式
  /// 手机号
  static const String findByPhoneNumberKey = "find_by_phone_number_key";

  /// wechatID
  static const String findByWechatIdKey = "find_by_wechat_id_key";

  /// QQ
  static const String findByQQKey = "find_by_qq_key";

  /// 群聊
  static const String addByChatGroupKey = "add_by_chat_group_key";

  /// 我的二维码
  static const String addByMyQrCodeKey = "add_by_my_qr_code_key";

  /// 名片
  static const String addByVisitingCardKey = "add_by_visiting_card_key";

  /// ---- 照片、视频和文件
  /// 自动下载
  static const String autoDownloadKey = "auto_download_key";

  /// 不让他
  static const String resourcePictureKey = "resource_picture_key";

  /// 视频
  static const String resourceVideoKey = "resource_video_key";

  /// 自动播放
  static const String videoAutoPlayKey = "video_auto_play_key";

  /// ---- 联系人-资料设置
  /// 设为星标朋友
  static const String settingToStarFriendKey = "setting_to_star_friend_key";

  /// 不让他看朋友圈
  static const String notAllowLookMyMomentsKey =
      "not_allow_look_my_moments_key";

  /// 不看他的朋友圈
  static const String notLookHisMomentsKey = "not_look_his_moments_key";

  /// 加入黑名单
  static const String joinToBlacklistKey = "join_to_blacklist_key";

  /// ---- 联系人-朋友权限
  /// 聊天、朋友圈、微信运动等
  static const String settingFriendPermissionKey =
      "setting_friend_permission_key";
}
