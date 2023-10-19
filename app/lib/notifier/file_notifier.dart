import "package:app/model/result_model.dart";
import "package:app/notifier/base_notifier.dart";

class FileNotifier extends BaseNotifier {
  void fileAdd({
    required url,
    required fileName,
    required fileType,
    required fileSize,
    required md5,
    required dirID,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      await fileApi.fileAdd(url, fileName, fileType, fileSize, md5, dirID).then((value) {
        if (value.state == true) {
          operationStatus.value = OperationStatus.success;
        } else {
          operationMemo = value.message;
        }
      });
    } catch (e) {
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void fileModify({
    required url,
    required id,
    required fileName,
    required dirID,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      await fileApi.fileModify(url, id, fileName, dirID).then((value) {
        if (value.state == true) {
          operationStatus.value = OperationStatus.success;
        } else {
          operationMemo = value.message;
        }
      });
    } catch (e) {
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<ResultModel> files({
    required url,
    required order,
    required fileName,
    required dirID,
  }) async {
    return await fileApi.files(url, order, fileName, dirID);
  }

  Future<ResultModel> fileDel({
    required url,
    required id,
  }) async {
    return await fileApi.fileDel(url, id);
  }
}
