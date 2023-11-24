class OriginalFileModel {
  int id;
  String fileName;
  String fileType;
  String fileSize;
  String md5;
  int dirID;
  String sourceAddress;

  OriginalFileModel({
    this.id = 0,
    this.fileName = "",
    this.fileType = "",
    this.fileSize = "",
    this.md5 = "",
    this.dirID = 0,
    this.sourceAddress = "",
  });

  factory OriginalFileModel.fromJson(Map<String, dynamic> json) {
    return OriginalFileModel(
      id: json["id"],
      fileName: json["fileName"],
      fileType: json["fileType"],
      fileSize: json["fileSize"],
      md5: json["md5"],
      dirID: json["dirID"],
      sourceAddress: json["sourceAddress"],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map["id"] = id;
    map["fileName"] = fileName;
    map["fileType"] = fileType;
    map["fileSize"] = fileSize;
    map["md5"] = md5;
    map["dirID"] = dirID;
    map["sourceAddress"] = sourceAddress;
    return map;
  }
}
