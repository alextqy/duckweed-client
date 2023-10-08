import "dart:async";
import "dart:convert";
import "package:http/http.dart";
import "package:app/common/file.dart";
import "package:app/api/base_api.dart";
import "package:app/model/result_model.dart";

class DirApi extends ResponseHelper {
  Future<ResultModel> dirs([
    url,
    order,
    parentID,
    dirName,
  ]) async {
    Response response = await post(
      Uri.http(url, "/dirs"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "order": order.toString(),
        "parentID": parentID.toString(),
        "dirName": dirName.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> dirAction([
    url,
    dirName,
    parentID,
    id,
  ]) async {
    Response response = await post(
      Uri.http(url, "/dir/action"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "dirName": dirName.toString(),
        "parentID": parentID.toString(),
        "id": id.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> dirInfo([
    url,
    id,
  ]) async {
    Response response = await post(
      Uri.http(url, "/dir/info"),
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
