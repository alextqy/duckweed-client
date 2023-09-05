import "package:app/model/result_model.dart";
import "package:app/notifier/base_notifier.dart";

class FileNotifier extends BaseNotifier {
  void fileAdd({
    fileName,
    fileType,
    fileSize,
    md5,
    dirID,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await fileApi.fileAdd(fileName, fileType, fileSize, md5, dirID);
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

  void fileModify({
    id,
    fileName,
    dirID,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await fileApi.fileModify(id, fileName, dirID);
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

  Future<ResultModel> files({
    order,
    fileName,
    dirID,
  }) async {
    return await fileApi.files(order, fileName, dirID);
  }

  void fileDel({
    id,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await fileApi.fileDel(id);
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
