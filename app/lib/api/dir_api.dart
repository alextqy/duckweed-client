import "dart:convert";
import "package:http/http.dart";
import "package:app/common/file.dart";
import "package:app/api/base_api.dart";
import "package:app/model/result_model.dart";

class DirApi extends ResponseHelper {
  Future<ResultModel> dirs([
    order,
    parentID,
    dirName,
  ]) async {
    Response response = await post(
      Uri.http(url, "/dirs"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "order": order,
        "parentID": parentID,
        "dirName": dirName,
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> dirAction([
    dirName,
    parentID,
    id,
  ]) async {
    Response response = await post(
      Uri.http(url, "/dir/action"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "dirName": dirName,
        "parentID": parentID,
        "id": id,
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }
}
