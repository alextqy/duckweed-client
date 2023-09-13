import 'dart:convert';

class AnnouncementModel {
  int id;
  String content;
  int createtime;

  AnnouncementModel({
    this.id = 0,
    this.content = "",
    this.createtime = 0,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json["ID"],
      content: json["Content"],
      createtime: json["Createtime"],
    );
  }

  List<AnnouncementModel> fromJsonList(String jsonString) {
    List<AnnouncementModel> dataList = (jsonDecode(jsonString) as List).map((i) => AnnouncementModel.fromJson(i)).toList();
    return dataList;
  }
}
