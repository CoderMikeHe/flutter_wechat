import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/views/login/login_router.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

import 'package:flutter_wechat/views/profile/chat_background/chat_background_page.dart';
import 'package:flutter_wechat/views/profile/discover_manager/discover_manager_page.dart';
import 'package:flutter_wechat/views/profile/resource/resource_page.dart';
import 'package:flutter_wechat/views/profile/chat_record_backup/chat_record_backup.dart';

class GeneralPage extends StatelessWidget {
  const GeneralPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('通用'),
      ),
      body: Container(
        child: _buildChildWidget(context),
      ),
    );
  }

  // 跳转设置语言
  void _skip2SettingLanguage(BuildContext context) {
    // 获取缓存中语言
    final String language =
        SpUtil.getString(CacheKey.appLanguageKey, defValue: '简体中文');
    // 跳转
    NavigatorUtils.pushResult(
      context,
      '${LoginRouter.languagePickerPage}?language=${Uri.encodeComponent(language)}',
      (result) {
        if (null != result && language != result) {
          // 保存缓存
          SpUtil.putString(CacheKey.appLanguageKey, result);
        }
      },
      transition: TransitionType.inFromBottom,
    );
  }

  /// 配置数据
  List<CommonGroup> _configData(BuildContext context) {
    // group0
    // 多语言
    final language = CommonItem(
      title: '多语言',
      onTap: (_) {
        _skip2SettingLanguage(context);
      },
    );
    final group0 = CommonGroup(
      items: [language],
    );

    // group1
    // 字体大小
    final fontSize = CommonItem(
      title: "字体大小",
    );
    // 聊天背景
    final chatBg = CommonItem(
      title: "聊天背景",
      onTap: (_) {
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (_) {
            return ChatBackgroundPage();
          },
        ));
      },
    );

    // 我的表情
    final myEmotion = CommonItem(
      title: "我的表情",
    );
    // 照片、视频和文件
    final resource = CommonItem(
      title: "照片、视频和文件",
      onTap: (_) {
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (_) {
            return ResourcePage();
          },
        ));
      },
    );
    final group1 = CommonGroup(
      items: [fontSize, chatBg, myEmotion, resource],
    );

    // group2
    // 听筒模式
    final receiverMode = CommonSwitchItem(
      title: "听筒模式",
      cacheKey: CacheKey.receiverModeKey,
    );

    final group2 = CommonGroup(
      items: [receiverMode],
    );

    // group3
    // 发现页管理
    final discoverManager = CommonItem(
      title: "发现页管理",
      onTap: (_) {
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (_) {
            return DiscoverManagerPage();
          },
        ));
      },
    );

    // 辅助功能
    final additionalFunction = CommonItem(
      title: "辅助功能",
    );
    final group3 = CommonGroup(
      items: [discoverManager, additionalFunction],
    );

    // group4
    // 聊天记录备份与迁移
    final chatRecord = CommonItem(
      title: "聊天记录备份与迁移",
      onTap: (_) {
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (_) {
            return ChatRecordBackupPage();
          },
        ));
      },
    );
    // 存储空间
    final storageSpace = CommonItem(title: "存储空间");
    final group4 = CommonGroup(
      items: [chatRecord, storageSpace],
    );

    // 清空聊天记录
    final clearChatHistory = CommonCenterItem(title: "清空聊天记录");
    final group5 = CommonGroup(
      items: [clearChatHistory],
    );

    // 添加数据源
    return [group0, group1, group2, group3, group4, group5];
  }

  /// 构建child
  Widget _buildChildWidget(BuildContext context) {
    // 获取数据
    final List<CommonGroup> dataSource = _configData(context);
    return ListView.builder(
      itemCount: dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        return CommonGroupWidget(
          group: dataSource[index],
        );
      },
    );
  }
}
