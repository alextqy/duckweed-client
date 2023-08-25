import "dart:convert";
import "package:http/http.dart";
import "package:app/common/file.dart";
import "package:app/api/base_api.dart";
import "package:app/model/result_model.dart";

class LogApi extends ResponseHelper {
  Future<ResultModel> viewLog([
    date,
    account,
  ]) async {
    Response response = await post(
      Uri.http(url, "/view/log"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "date": date,
        "account": account,
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }
}
