import "package:app/model/result_model.dart";
import "package:app/model/result_list_model.dart";
import "package:app/notifier/base_notifier.dart";
import "package:app/common/file.dart";

class UserNotifier extends BaseNotifier {
  void signIn({
    required url,
    required account,
    required password,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.signIn(url, account, password);
      if (result.state == true) {
        if (FileHelper().writeFile("token", result.data)) {
          operationStatus.value = OperationStatus.success;
        }
      } else {
        operationMemo = result.message;
      }
    } catch (e) {
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void signOut({
    required url,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.signOut(url);
      if (result.state == true) {
        operationStatus.value = OperationStatus.success;
      } else {
        operationMemo = result.message;
      }
    } catch (e) {
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<ResultListModel> userList({
    required url,
    required page,
    required pageSize,
    required order,
    required account,
    required name,
    required level,
    required status,
  }) async {
    return await userApi.userList(url, page, pageSize, order, account, name, level, status);
  }

  Future<ResultModel> users({
    required url,
    required order,
    required account,
    required name,
    required level,
    required status,
  }) async {
    return await userApi.users(url, order, account, name, level, status);
  }

  Future<ResultModel> userGet({
    required url,
    required id,
  }) async {
    return await userApi.userGet(url, id);
  }

  void setAvailableSpace({
    required url,
    required id,
    required availableSpace,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.setAvailableSpace(url, id, availableSpace);
      if (result.state == true) {
        operationStatus.value = OperationStatus.success;
      } else {
        operationMemo = result.message;
      }
    } catch (e) {
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void disableUser({
    required url,
    required id,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.disableUser(url, id);
      if (result.state == true) {
        operationStatus.value = OperationStatus.success;
      } else {
        operationMemo = result.message;
      }
    } catch (e) {
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void userDel({
    required url,
    required id,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.userDel(url, id);
      if (result.state == true) {
        operationStatus.value = OperationStatus.success;
      } else {
        operationMemo = result.message;
      }
    } catch (e) {
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void sendEmailSignUp({
    required url,
    required email,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.sendEmailSignUp(url, email);
      if (result.state == true) {
        operationStatus.value = OperationStatus.success;
      } else {
        operationMemo = result.message;
      }
    } catch (e) {
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void signUp({
    required url,
    required account,
    required name,
    required password,
    required email,
    required captcha,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.signUp(url, account, name, password, email, captcha);
      if (result.state == true) {
        operationStatus.value = OperationStatus.success;
      } else {
        operationMemo = result.message;
      }
    } catch (e) {
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<ResultModel> checkPersonalData({
    required url,
  }) async {
    return await userApi.checkPersonalData(url);
  }

  void modifyPersonalData({
    required url,
    required name,
    required password,
    required email,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.modifyPersonalData(url, name, password, email);
      if (result.state == true) {
        operationStatus.value = OperationStatus.success;
      } else {
        operationMemo = result.message;
      }
    } catch (e) {
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void sendEmail({
    required url,
    required email,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.sendEmail(url, email);
      if (result.state == true) {
        operationStatus.value = OperationStatus.success;
      } else {
        operationMemo = result.message;
      }
    } catch (e) {
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void resetPassword({
    required url,
    required newPassword,
    required captcha,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.resetPassword(url, newPassword, captcha);
      if (result.state == true) {
        operationStatus.value = OperationStatus.success;
      } else {
        operationMemo = result.message;
      }
    } catch (e) {
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
