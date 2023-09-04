import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:app/common/file.dart';
import 'package:app/api/base_api.dart';
import 'package:app/model/result_model.dart';

class AnnouncementApi extends ResponseHelper {
  Future<ResultModel> announcements() async {
    try {
      Response response = await post(
        Uri.http(url, '/announcements'),
        body: {
          'userToken': FileHelper().readFile('token'),
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

  Future<ResultModel> announcementGet([
    id,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, '/announcement/get'),
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

  Future<ResultModel> announcementAdd([
    content,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, '/announcement/add'),
        body: {
          'userToken': FileHelper().readFile('token'),
          'content': content,
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

  Future<ResultModel> announcementDel([
    id,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, '/announcement/del'),
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
