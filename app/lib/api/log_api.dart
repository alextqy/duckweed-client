import "dart:async";
import "dart:convert";
import "package:http/http.dart";
import "package:app/common/file.dart";
import "package:app/api/base_api.dart";
import "package:app/model/result_model.dart";

class LogApi extends ResponseHelper {
  Future<ResultModel> viewLog([
    url,
    date,
    account,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/view/log"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "date": date.toString(),
          "account": account.toString(),
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
