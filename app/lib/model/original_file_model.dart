class OriginalFileModel {
  String fileName;
  String fileType;
  String fileSize;
  String md5;
  int parentID;

  OriginalFileModel({
    this.fileName = "",
    this.fileType = "",
    this.fileSize = "",
    this.md5 = "",
    this.parentID = 0,
  });

  factory OriginalFileModel.fromJson(Map<String, dynamic> json) {
    return OriginalFileModel(
      fileName: json["fileName"],
      fileType: json["fileType"],
      fileSize: json["fileSize"],
      md5: json["md5"],
      parentID: json["parentID"],
    );
  }
}
