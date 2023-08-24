class ResultListModel {
  bool state = false;
  int code = 0;
  String message = "";
  int page = 0;
  int pageSize = 0;
  int totalPage = 0;
  dynamic data;

  ResultListModel({
    this.state = false,
    this.code = 0,
    this.message = "",
    this.page = 0,
    this.pageSize = 0,
    this.totalPage = 0,
    this.data = "",
  });

  factory ResultListModel.fromJson(Map<String, dynamic> json) {
    return ResultListModel(
      state: json["State"],
      code: json["Code"],
      message: json["Message"],
      page: json["Page"],
      pageSize: json["PageSize"],
      totalPage: json["TotalPage"],
      data: json["Data"],
    );
  }
}
