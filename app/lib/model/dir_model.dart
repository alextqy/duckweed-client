import 'dart:convert';

class DirModel {
  int id;
  String dirName;
  int parentID;
  int userID;
  int createtime;

  DirModel({
    this.id = 0,
    this.dirName = "",
    this.parentID = 0,
    this.userID = 0,
    this.createtime = 0,
  });

  factory DirModel.fromJson(Map<String, dynamic> json) {
    return DirModel(
      id: json["ID"],
      dirName: json["DirName"],
      parentID: json["ParentID"],
      userID: json["UserID"],
      createtime: json["Createtime"],
    );
  }

  List<DirModel> fromJsonList(String jsonString) {
    List<DirModel> dataList = (jsonDecode(jsonString) as List).map((i) => DirModel.fromJson(i)).toList();
    return dataList;
  }
}
