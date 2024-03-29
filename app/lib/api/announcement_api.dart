import "dart:async";
import "dart:convert";
import "package:http/http.dart";
import "package:app/common/file.dart";
import "package:app/api/base_api.dart";
import "package:app/model/result_model.dart";

class AnnouncementApi extends ResponseHelper {
  Future<ResultModel> announcements([url]) async {
    Response response = await post(
      Uri.http(url, "/announcements"),
      body: {
        "userToken": FileHelper().readFile("token"),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> announcementGet([
    url,
    id,
  ]) async {
    Response response = await post(
      Uri.http(url, "/announcement/get"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "id": id.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> announcementAdd([
    url,
    content,
  ]) async {
    Response response = await post(
      Uri.http(url, "/announcement/add"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "content": content.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> announcementDel([
    url,
    id,
  ]) async {
    Response response = await post(
      Uri.http(url, "/announcement/del"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "id": id.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }
}
