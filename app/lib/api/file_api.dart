import "dart:async";
import "dart:convert";
import "package:http/http.dart";
import "package:app/common/file.dart";
import "package:app/api/base_api.dart";
import "package:app/model/result_model.dart";

class FileApi extends ResponseHelper {
  Future<ResultModel> fileAdd([
    url,
    fileName,
    fileType,
    fileSize,
    md5,
    dirID,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/file/add"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "fileName": fileName.toString(),
          "fileType": fileType.toString(),
          "fileSize": fileSize.toString(),
          "md5": md5.toString(),
          "dirID": dirID.toString(),
        },
        headers: postHeaders,
        encoding: postEncoding,
      ).timeout(Duration(seconds: timeout));
      return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
    } on TimeoutException catch (e) {
      return ResultModel(code: 200, message: e.toString());
    } catch (e) {
      return ResultModel(code: 200, message: e.toString());
    }
  }

  Future<ResultModel> fileModify([
    url,
    id,
    fileName,
    dirID,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/file/modify"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "id": id.toString(),
          "fileName": fileName.toString(),
          "dirID": dirID.toString(),
        },
        headers: postHeaders,
        encoding: postEncoding,
      ).timeout(Duration(seconds: timeout));
      return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
    } on TimeoutException catch (e) {
      return ResultModel(code: 200, message: e.toString());
    } catch (e) {
      return ResultModel(code: 200, message: e.toString());
    }
  }

  Future<ResultModel> files([
    url,
    order,
    fileName,
    dirID,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/files"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "order": order.toString(),
          "fileName": fileName.toString(),
          "dirID": dirID.toString(),
        },
        headers: postHeaders,
        encoding: postEncoding,
      ).timeout(Duration(seconds: timeout));
      return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
    } on TimeoutException catch (e) {
      return ResultModel(code: 200, message: e.toString());
    } catch (e) {
      return ResultModel(code: 200, message: e.toString());
    }
  }

  Future<ResultModel> fileDel([
    url,
    id,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/file/del"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "id": id.toString(),
        },
        headers: postHeaders,
        encoding: postEncoding,
      ).timeout(Duration(seconds: timeout));
      return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
    } on TimeoutException catch (e) {
      return ResultModel(code: 200, message: e.toString());
    } catch (e) {
      return ResultModel(code: 200, message: e.toString());
    }
  }
}
