class OriginalFileModel {
  String fileName;
  String fileType;
  String fileSize;
  String md5;
  int dirID;

  OriginalFileModel({
    this.fileName = "",
    this.fileType = "",
    this.fileSize = "",
    this.md5 = "",
    this.dirID = 0,
  });

  factory OriginalFileModel.fromJson(Map<String, dynamic> json) {
    return OriginalFileModel(
      fileName: json["fileName"],
      fileType: json["fileType"],
      fileSize: json["fileSize"],
      md5: json["md5"],
      dirID: json["dirID"],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map["fileName"] = fileName;
    map["fileType"] = fileType;
    map["fileSize"] = fileSize;
    map["md5"] = md5;
    map["dirID"] = dirID;
    return map;
  }
}
