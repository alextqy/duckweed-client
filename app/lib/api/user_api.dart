import "dart:async";
import "dart:convert";
import "package:http/http.dart";
import "package:app/common/file.dart";
import "package:app/api/base_api.dart";
import "package:app/model/result_model.dart";
import "package:app/model/result_list_model.dart";

class UserApi extends ResponseHelper {
  Future<ResultModel> signIn([
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

  Future<ResultModel> signOut() async {
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

  Future<ResultModel> signUp([
    account,
    name,
    password,
    email,
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

  Future<ResultModel> checkPersonalData() async {
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
