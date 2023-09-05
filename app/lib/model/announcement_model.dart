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
}
