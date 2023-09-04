import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:app/common/file.dart';
import 'package:app/api/base_api.dart';
import 'package:app/model/result_model.dart';

class FileApi extends ResponseHelper {
  Future<ResultModel> fileAdd([
    fileName,
    fileType,
    fileSize,
    md5,
    dirID,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, '/file/add'),
        body: {
          'userToken': FileHelper().readFile('token'),
          'fileName': fileName,
          'fileType': fileType,
          'fileSize': fileSize,
          'md5': md5,
          'dirID': dirID,
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
    id,
    fileName,
    dirID,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, '/file/modify'),
        body: {
          'userToken': FileHelper().readFile('token'),
          'id': id,
          'fileName': fileName,
          'dirID': dirID,
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
    order,
    fileName,
    dirID,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, '/files'),
        body: {
          'userToken': FileHelper().readFile('token'),
          'order': order,
          'fileName': fileName,
          'dirID': dirID,
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
    id,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, '/file/del'),
        body: {
          'userToken': FileHelper().readFile('token'),
          'id': id,
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
