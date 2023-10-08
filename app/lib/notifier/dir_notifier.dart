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
      await dirApi.dirAction(url, dirName, parentID, id).then((value) {
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

  Future<ResultModel> dirInfo({
    required url,
    required id,
  }) async {
    return await dirApi.dirInfo(url, id);
  }
}
