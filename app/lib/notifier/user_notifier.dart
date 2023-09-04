import 'package:app/model/result_model.dart';
import 'package:app/model/result_list_model.dart';
import 'package:app/notifier/base_notifier.dart';
import 'package:app/common/file.dart';

class UserNotifier extends BaseNotifier {
  void signIn({
    account,
    password,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.signIn(account, password);
      if (result.state == true) {
        if (FileHelper().writeFile('token', result.data)) {
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

  void signOut() async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.signOut();
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
    page,
    pageSize,
    order,
    account,
    name,
    level,
    status,
  }) async {
    return await userApi.userList(page, pageSize, order, account, name, level, status);
  }

  Future<ResultModel> users({
    order,
    account,
    name,
    level,
    status,
  }) async {
    return await userApi.users(order, account, name, level, status);
  }

  Future<ResultModel> userGet({
    id,
  }) async {
    return await userApi.userGet(id);
  }

  void setAvailableSpace({
    id,
    availableSpace,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.setAvailableSpace(id, availableSpace);
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
    id,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.disableUser(id);
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
    id,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.userDel(id);
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
    email,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.sendEmailSignUp(email);
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
    account,
    name,
    password,
    email,
    captcha,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.signUp(account, name, password, email, captcha);
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

  Future<ResultModel> checkPersonalData() async {
    return await userApi.checkPersonalData();
  }

  void modifyPersonalData({
    name,
    password,
    email,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.modifyPersonalData(name, password, email);
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
    email,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.sendEmail(email);
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
    newPassword,
    captcha,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await userApi.resetPassword(newPassword, captcha);
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
