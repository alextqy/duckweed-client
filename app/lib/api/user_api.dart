import "dart:async";
import "dart:convert";
import "package:http/http.dart";
import "package:app/common/file.dart";
import "package:app/api/base_api.dart";
import "package:app/model/result_model.dart";
import "package:app/model/result_list_model.dart";

class UserApi extends ResponseHelper {
  Future<ResultModel> test(
    url,
  ) async {
    Response response = await post(
      Uri.http(url, "/test"),
      body: {},
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> signIn([
    url,
    account,
    password,
  ]) async {
    Response response = await post(
      Uri.http(url, "/sign/in"),
      body: {
        "account": account.toString(),
        "password": password.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> signOut([
    url,
  ]) async {
    Response response = await post(
      Uri.http(url, "/sign/out"),
      body: {
        "userToken": FileHelper().readFile("token"),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultListModel> userList([
    url,
    page,
    pageSize,
    order,
    account,
    name,
    level,
    status,
  ]) async {
    Response response = await post(
      Uri.http(url, "/user/list"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "page": page.toString(),
        "pageSize": pageSize.toString(),
        "order": order.toString(),
        "account": account.toString(),
        "name": name.toString(),
        "level": level.toString(),
        "status": status.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultListModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> users([
    url,
    order,
    account,
    name,
    level,
    status,
  ]) async {
    Response response = await post(
      Uri.http(url, "/users"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "order": order.toString(),
        "account": account.toString(),
        "name": name.toString(),
        "level": level.toString(),
        "status": status.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> userGet([
    url,
    id,
  ]) async {
    Response response = await post(
      Uri.http(url, "/user/get"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "id": id.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> setAvailableSpace([
    url,
    id,
    availableSpace,
  ]) async {
    Response response = await post(
      Uri.http(url, "/set/available/space"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "id": id.toString(),
        "availableSpace": availableSpace.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> setRootAccount([
    url,
    id,
  ]) async {
    Response response = await post(
      Uri.http(url, "/set/root/account"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "id": id.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> disableUser([
    url,
    id,
  ]) async {
    Response response = await post(
      Uri.http(url, "/disable/user"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "id": id.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> userDel([
    url,
    id,
  ]) async {
    Response response = await post(
      Uri.http(url, "/user/del"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "id": id.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> signUp([
    url,
    account,
    name,
    password,
    email,
    captcha,
  ]) async {
    Response response = await post(
      Uri.http(url, "/sign/up"),
      body: {
        "account": account.toString(),
        "name": name.toString(),
        "password": password.toString(),
        "email": email.toString(),
        "captcha": captcha.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> checkPersonalData([
    url,
  ]) async {
    Response response = await post(
      Uri.http(url, "/check/personal/data"),
      body: {
        "userToken": FileHelper().readFile("token"),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> modifyPersonalData([
    url,
    name,
    password,
    email,
    captcha,
  ]) async {
    Response response = await post(
      Uri.http(url, "/modify/personal/data"),
      body: {
        "userToken": FileHelper().readFile("token"),
        "name": name.toString(),
        "password": password.toString(),
        "email": email.toString(),
        "captcha": captcha.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> resetPassword([
    url,
    newPassword,
    captcha,
  ]) async {
    Response response = await post(
      Uri.http(url, "/reset/password"),
      body: {
        "newPassword": newPassword.toString(),
        "captcha": captcha.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<ResultModel> sendEmail([
    url,
    email,
    sendType,
  ]) async {
    Response response = await post(
      Uri.http(url, "/send/email"),
      body: {
        "email": email.toString(),
        "sendType": sendType.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    ).timeout(Duration(seconds: timeout));
    return ResultModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }
}
