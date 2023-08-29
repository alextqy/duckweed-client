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

  Lang() {
    this.type = FileHelper().jsonRead(key: "lang", filePath: "config.json");
    this.title = FileHelper().jsonRead(key: "title", filePath: "config.json");

    if (this.type == "cn") {
      this.requestTimedOut = "请求超时";
      this.signIn = "登录";
      this.signOut = "退出";
      this.network = "网络";
      this.forgotPassword = "找回密码";
      this.signUp = "注册";
    } else {
      this.requestTimedOut = "Request timed out";
      this.signIn = "Sign in";
      this.signOut = "Sign out";
      this.network = "Network";
      this.forgotPassword = "Forgot Password";
      this.signUp = "Sign Up";
    }
  }
}
