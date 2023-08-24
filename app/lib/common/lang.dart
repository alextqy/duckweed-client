// ignore_for_file: unnecessary_this

import "package:app/common/file.dart";

class Lang {
  String type = "";
  String title = "";
  String requestTimedOut = "";
  String cancel = "";

  Lang() {
    this.type = FileHelper().jsonRead(key: "lang", filePath: "config.json");
    this.title = FileHelper().jsonRead(key: "title", filePath: "config.json");
    if (this.type == "cn") {
      this.requestTimedOut = "请求超时";
    } else {
      this.requestTimedOut = "request timed out";
    }
  }
}
