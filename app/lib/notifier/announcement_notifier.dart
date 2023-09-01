import "package:app/notifier/base_notifier.dart";
import "package:app/model/result_model.dart";

class AnnouncementNotifier extends BaseNotifier {
  Future<ResultModel> announcements() async {
    return await announcementApi.announcements();
  }

  void announcementGet({
    id,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await announcementApi.announcementGet(id);
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

  void announcementAdd({
    content,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await announcementApi.announcementAdd(content);
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

  void announcementDel({
    id,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await announcementApi.announcementDel(id);
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
