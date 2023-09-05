import "dart:async";
import "dart:convert";
import "package:http/http.dart";
import "package:app/common/file.dart";
import "package:app/api/base_api.dart";
import "package:app/model/result_model.dart";
import "package:app/model/result_list_model.dart";

class UserApi extends ResponseHelper {
  Future<ResultModel> signIn([
    url,
    account,
    password,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/sign/in"),
        body: {
          "account": account,
          "password": password,
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

  Future<ResultModel> signOut([
    url,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/sign/out"),
        body: {
          "userToken": FileHelper().readFile("token"),
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
    try {
      Response response = await post(
        Uri.http(url, "/user/list"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "page": page,
          "pageSize": pageSize,
          "order": order,
          "account": account,
          "name": name,
          "level": level,
          "status": status,
        },
        headers: postHeaders,
        encoding: postEncoding,
      ).timeout(Duration(seconds: timeout));
      return ResultListModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
    } on TimeoutException catch (e) {
      return ResultListModel(code: 200, message: e.toString());
    } catch (e) {
      return ResultListModel(code: 200, message: e.toString());
    }
  }

  Future<ResultModel> users([
    url,
    order,
    account,
    name,
    level,
    status,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/users"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "order": order,
          "account": account,
          "name": name,
          "level": level,
          "status": status,
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

  Future<ResultModel> userGet([
    url,
    id,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/user/get"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "id": id,
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

  Future<ResultModel> setAvailableSpace([
    url,
    id,
    availableSpace,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/set/available/space"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "id": id,
          "availableSpace": availableSpace,
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

  Future<ResultModel> disableUser([
    url,
    id,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/disable/user"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "id": id,
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

  Future<ResultModel> userDel([
    url,
    id,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/user/del"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "id": id,
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

  Future<ResultModel> sendEmailSignUp([
    url,
    email,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/send/email/sign/up"),
        body: {
          "email": email,
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

  Future<ResultModel> signUp([
    url,
    account,
    name,
    password,
    email,
    captcha,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/sign/up"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "account": account,
          "name": name,
          "password": password,
          "email": email,
          "captcha": captcha,
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

  Future<ResultModel> checkPersonalData([
    url,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/check/personal/data"),
        body: {
          "userToken": FileHelper().readFile("token"),
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

  Future<ResultModel> modifyPersonalData([
    url,
    name,
    password,
    email,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/modify/personal/data"),
        body: {
          "userToken": FileHelper().readFile("token"),
          "name": name,
          "password": password,
          "email": email,
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

  Future<ResultModel> sendEmail([
    url,
    email,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/send/email"),
        body: {
          "email": email,
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

  Future<ResultModel> resetPassword([
    url,
    newPassword,
    captcha,
  ]) async {
    try {
      Response response = await post(
        Uri.http(url, "/reset/password"),
        body: {
          "newPassword": newPassword,
          "captcha": captcha,
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
