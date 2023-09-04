import 'package:app/notifier/base_notifier.dart';
import 'package:app/model/result_model.dart';

class DirNotifier extends BaseNotifier {
  Future<ResultModel> dirs({
    order,
    parentID,
    dirName,
  }) async {
    return await dirApi.dirs(order, parentID, dirName);
  }

  void dirAction({
    dirName,
    parentID,
    id,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await dirApi.dirAction(dirName, parentID, id);
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
