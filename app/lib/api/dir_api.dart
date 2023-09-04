import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:app/common/file.dart';
import 'package:app/api/base_api.dart';
import 'package:app/model/result_model.dart';

class DirApi extends ResponseHelper {
  Future<ResultModel> dirs([
    order,
    parentID,
    dirName,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, '/dirs'),
        body: {
          'userToken': FileHelper().readFile('token'),
          'order': order,
          'parentID': parentID,
          'dirName': dirName,
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

  Future<ResultModel> dirAction([
    dirName,
    parentID,
    id,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, '/dir/action'),
        body: {
          'userToken': FileHelper().readFile('token'),
          'dirName': dirName,
          'parentID': parentID,
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
