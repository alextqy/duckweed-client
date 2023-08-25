// ignore_for_file: file_names

// import "dart:io";

import "package:flutter/widgets.dart";
import "package:app/model/result_model.dart";
import "package:app/model/result_list_model.dart";

import "package:app/model/announcement_model.dart";
import "package:app/model/dir_model.dart";
import "package:app/model/file_model.dart";
import "package:app/model/user_model.dart";

import "package:app/api/user_api.dart";
import "package:app/api/announcement_api.dart";
import "package:app/api/log_api.dart";
import "package:app/api/dir_api.dart";
import "package:app/api/file_api.dart";

enum OperationStatus {
  init, // 加载中
  loading, // 加载中
  success, // 加载成功
  empty, // 加载成功，但数据为空
  failure, // 加载失败
  disconnection, // 请求失败
}

class ApiResponse<T> {
  OperationStatus status;
  T? data;
  String? message;

  ApiResponse.init(this.message) : status = OperationStatus.init;
  ApiResponse.loading(this.message) : status = OperationStatus.loading;
  ApiResponse.success(this.data) : status = OperationStatus.success;
  ApiResponse.empty(this.message) : status = OperationStatus.empty;
  ApiResponse.failure(this.message) : status = OperationStatus.failure;
  ApiResponse.disconnection(this.message) : status = OperationStatus.disconnection;
}

class BaseNotifier extends ChangeNotifier {
  ValueNotifier operationStatus = ValueNotifier(OperationStatus.loading);
  String operationMemo = "";
  int operationCode = 0;

  late ResultModel result;
  late ResultListModel resultList;

  /// model ===================================================================

  AnnouncementModel announcementModel = AnnouncementModel();
  DirModel dirModel = DirModel();
  FileModel fileMode = FileModel();
  UserModel userModel = UserModel();

  List<AnnouncementModel> announcementListModel = [];
  List<DirModel> dirListModel = [];
  List<FileModel> fileListModel = [];
  List<UserModel> userListModel = [];

  /// api ===================================================================
  UserApi userApi = UserApi();
  AnnouncementApi announcementApi = AnnouncementApi();
  LogApi logApi = LogApi();
  DirApi dirApi = DirApi();
  FileApi fileApi = FileApi();
}
