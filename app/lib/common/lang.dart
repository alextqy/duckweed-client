// ignore_for_file: unnecessary_this

import "package:app/common/file.dart";

class Lang {
  String type = "";
  String title = "";

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

  Lang() {
    this.type = FileHelper().jsonRead(key: "lang");
    this.title = FileHelper().jsonRead(key: "title");

    if (this.type == "cn") {
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
    } else {
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
    }
  }
}
