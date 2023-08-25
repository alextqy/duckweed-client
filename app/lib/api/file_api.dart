import "dart:convert";
import "package:http/http.dart";
import "package:app/common/file.dart";
import "package:app/api/base_api.dart";
import "package:app/model/result_model.dart";

class FileApi extends ResponseHelper {
  Future<ResultModel> fileAdd([
    fileName,
    fileType,
    fileSize,
    md5,
    dirID,
  ]) async {
    Response response = await post(
      Uri.http(url, "/file/add"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "fileName": fileName,
        "fileType": fileType,
        "fileSize": fileSize,
        "md5": md5,
        "dirID": dirID,
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> fileModify([
    id,
    fileName,
    dirID,
  ]) async {
    Response response = await post(
      Uri.http(url, "/file/modify"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "id": id,
        "fileName": fileName,
        "dirID": dirID,
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> files([
    order,
    fileName,
    dirID,
  ]) async {
    Response response = await post(
      Uri.http(url, "/files"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "order": order,
        "fileName": fileName,
        "dirID": dirID,
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> fileDel([
    id,
  ]) async {
    Response response = await post(
      Uri.http(url, "/file/del"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "id": id,
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }
}
