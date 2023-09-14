// ignore_for_file: unnecessary_this

import "package:app/common/file.dart";

class Lang {
  String type = "";
  String title = "";

  String theServerAddressIsIncorrect = "";
  String testConnection = "";
  String operationFailed = "";
  String requestTimedOut = "";
  String cancel = "";
  String signIn = "";
  String signOut = "";
  String network = "";
  String forgotPassword = "";
  String signUp = "";
  String account = "";
  String password = "";
  String typo = "";
  String loading = "";
  String complete = "";
  String email = "";
  String captcha = "";
  String newPassword = "";
  String nickName = "";
  String serverAddress = "";
  String automaticDetection = "";
  String invalidPage = "";
  String longPressToExit = "";
  String exit = "";
  String personalSettings = "";
  String home = "";
  String users = "";
  String announcements = "";
  String systemLog = "";
  String yes = "";
  String no = "";
  String confirm = "";

  String root = "";
  String availableSpace = "";
  String createtime = "";

  Lang() {
    this.type = FileHelper().jsonRead(key: "lang");
    this.title = FileHelper().jsonRead(key: "title");

    if (this.type == "cn") {
      this.theServerAddressIsIncorrect = "服务器地址未设置";
      this.testConnection = "测试连接";
      this.operationFailed = "操作失败";
      this.requestTimedOut = "请求超时";
      this.signIn = "登录";
      this.signOut = "退出";
      this.network = "网络";
      this.forgotPassword = "找回密码";
      this.signUp = "注册";
      this.account = "账号";
      this.password = "密码";
      this.typo = "输入错误";
      this.loading = "加载中";
      this.complete = "完成";
      this.email = "邮件";
      this.captcha = "验证码";
      this.newPassword = "新密码";
      this.nickName = "昵称";
      this.serverAddress = "服务器地址";
      this.automaticDetection = "自动检测";
      this.invalidPage = "页面错误";
      this.longPressToExit = "长按退出";
      this.exit = "退出";
      this.personalSettings = "个人设置";
      this.home = "首页";
      this.users = "用户";
      this.announcements = "公告";
      this.systemLog = "系统日志";
      this.yes = "是";
      this.no = "否";
      this.confirm = "确认";

      this.root = "超级用户";
      this.availableSpace = "可用空间";
      this.createtime = "创建时间";
    } else {
      this.theServerAddressIsIncorrect = "The server address is incorrect";
      this.testConnection = "Test connection";
      this.operationFailed = "Operation failed";
      this.requestTimedOut = "Request timed out";
      this.signIn = "Sign in";
      this.signOut = "Sign out";
      this.network = "Network";
      this.forgotPassword = "Forgot Password";
      this.signUp = "Sign Up";
      this.account = "Account";
      this.password = "Password";
      this.typo = "Typo";
      this.loading = "Loading";
      this.complete = "Complete";
      this.email = "Email";
      this.captcha = "Captcha";
      this.newPassword = "New Password";
      this.nickName = "Nick name";
      this.serverAddress = "Server Address";
      this.automaticDetection = "Automatic detection";
      this.invalidPage = "Invalid Page";
      this.longPressToExit = "Long press to exit";
      this.exit = "Exit";
      this.personalSettings = "Personal settings";
      this.home = "Home";
      this.users = "Users";
      this.announcements = "Notice";
      this.systemLog = "Log";
      this.yes = "Yes";
      this.no = "No";
      this.confirm = "Confirm";

      this.root = "Root";
      this.availableSpace = "Available space";
      this.createtime = "Createtime";
    }
  }
}
