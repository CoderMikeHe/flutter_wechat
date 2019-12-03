# flutter_wechat

<img src="https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/logo.png" width="256px" height="256px" />

### 一、概述

- 利用`Flutter` 来构建和模仿`微信7.0.0+ App`，且都是按照`原生微信App`页面，来开发和模仿滴，从而达到与原生 app 相近的视觉效果。

- 笔者于**2019 年 08 月**入坑`Flutter`开发学习，纯属小白一枚，此项目初衷还是想通过项目实践新技术，在业务实践中发现问题，从而积累技术经验，源码中有详细的注释，以及发现问题和解决问题的思路。

- 笔者希望初学者通过学习和实践这个项目，能够打开学习`Flutter`的大门。当然同时也是抛砖引玉，取长补短，希望能够提供一点思路，少走一些弯路，填补一些细坑，在帮助他人的过程中，收获分享技术的乐趣。

---

### 二、使用

- 项目运行
  `flutter packages get // 项目初始化插件 flutter run // 项目运行`
- **使用注意**

  - 还请优先使用`iPhone 7/8 Plus`的模拟器或真机，来运行整个项目. 根本原因：目前可能部分界面还未做完屏幕适配，以及笔者生前是一名`iOS开发`且用的是`iPhone 7 Plus`手机。

  - 登陆和注册：目前只支持`QQ账号`和`手机号`的登录或注册（PS：后期增加`微信号和QQ邮箱`登陆），且必须保证`QQ`或`手机号`的有效性。`密码`或者`验证码`可以随便输入，但必须是：`密码`长度需要保证在`8~16`位，`手机验证码`必须保证是`6位有效数字`

---

### 三、期待

- 如果在使用过程中遇到 BUG，希望你能 Issues 我，谢谢（或者尝试下载最新的代码看看 BUG 修复没有）。
- 如果在使用过程中有任何地方不理解，希望你能 Issues 我，我非常乐意促使项目的理解和使用，谢谢。
- 如果通过该工程的使用和说明文档的阅读，对你在平时开发中有帮助，码字不易，还请点击右上角`Star`或`Fork`按钮，谢谢。
- 简书地址：<http://www.jianshu.com/u/126498da7523>

---

### 四、文档

- [Flutter 玩转微信——通讯录](https://www.jianshu.com/p/8d136f31b8a2)

### 五、预览

###### 闪屏模块

| ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/splash/splash_page_0.png) | ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/splash/splash_page_1.png) | ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/splash/splash_page_2.png) |
| :------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------: |


###### 登陆/注册模块

|    ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/login/login_page.png)    |   ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/login/register_page.png)    |   ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/login/other_login_page.png)   |
| :--------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------: |
| ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/login/phone_login_page.png) | ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/login/current_login_page.png) | ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/login/language_picker_page.png) |

###### 微信模块

| ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/mainframe/mainframe_page_0.png) | 虚位以待 | 虚位以待 |
| :------------------------------------------------------------------------------------------------------: | :------: | :------: |


###### 通讯录模块

| ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/contacts/contacts_page_0.png) | ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/contacts/contacts_page_1.png) | ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/contacts/contacts_page_2.png) |
| :----------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------: |


###### 发现模块

| ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/discover/discover_page_0.png) | 虚位以待 | 虚位以待 |
| :----------------------------------------------------------------------------------------------------: | :------: | :------: |


###### 我模块

| ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/profile/profile_page_0.png) | ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/profile/user_info_page.png) | ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/profile/more_info_page.png) |
| :--------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------: |


###### 设置模块

| ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/setting/setting_page.png)  | ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/setting/account_security_page.png) | ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/setting/message_notify_page.png) |
| :-------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------: |
| ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/setting/privates_page.png) |     ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/setting/general_page.png)      |  ![](https://github.com/CoderMikeHe/WeChat_Resource/blob/master/snapshots/setting/about_wechat_page.png)  |
