import "package:app/notifier/base_notifier.dart";
import "package:app/model/result_model.dart";

class DirNotifier extends BaseNotifier {
  Future<ResultModel> dirs({
    required url,
    required order,
    required parentID,
    required dirName,
  }) async {
    return await dirApi.dirs(url, order, parentID, dirName);
  }

  void dirAction({
    required url,
    required dirName,
    required parentID,
    required id,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await dirApi.dirAction(url, dirName, parentID, id);
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
