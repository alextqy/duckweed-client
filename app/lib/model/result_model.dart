class ResultModel {
  bool state;
  int code;
  String message;
  dynamic data;

  ResultModel({
    this.state = false,
    this.code = 0,
    this.message = '',
    this.data = '',
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      state: json['State'],
      code: json['Code'],
      message: json['Message'],
      data: json['Data'],
    );
  }
}
