import "dart:convert";

class UserModel {
  int id;
  String account;
  String name;
  String password;
  int level;
  int status;
  int availableSpace;
  int usedSpace;
  int createtime;
  String userToken;
  String email;
  String captcha;

  UserModel({
    this.id = 0,
    this.account = "",
    this.name = "",
    this.password = "",
    this.level = 0,
    this.status = 0,
    this.availableSpace = 0,
    this.usedSpace = 0,
    this.createtime = 0,
    this.userToken = "",
    this.email = "",
    this.captcha = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["ID"],
      account: json["Account"],
      name: json["Name"],
      password: json["Password"],
      level: json["Level"],
      status: json["Status"],
      availableSpace: json["AvailableSpace"],
      usedSpace: json["UsedSpace"],
      createtime: json["Createtime"],
      userToken: json["UserToken"],
      email: json["Email"],
      captcha: json["Captcha"],
    );
  }

  List<UserModel> fromJsonList(String jsonString) {
    List<UserModel> dataList = (jsonDecode(jsonString) as List).map((i) => UserModel.fromJson(i)).toList();
    return dataList;
  }
}
