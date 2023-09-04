class FileModel {
  int id;
  String fileName;
  String fileType;
  String fileSize;
  String storagePath;
  String md5;
  int userID;
  int dirID;
  int createtime;
  int status;
  String outreachID;

  FileModel({
    this.id = 0,
    this.fileName = '',
    this.fileType = '',
    this.fileSize = '',
    this.storagePath = '',
    this.md5 = '',
    this.userID = 0,
    this.dirID = 0,
    this.createtime = 0,
    this.status = 0,
    this.outreachID = '',
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['ID'],
      fileName: json['FileName'],
      fileType: json['FileType'],
      fileSize: json['FileSize'],
      storagePath: json['StoragePath'],
      md5: json['MD5'],
      userID: json['UserID'],
      dirID: json['DirID'],
      createtime: json['Createtime'],
      status: json['Status'],
      outreachID: json['OutreachID'],
    );
  }
}
