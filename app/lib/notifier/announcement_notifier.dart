import "package:app/notifier/base_notifier.dart";
import "package:app/model/result_model.dart";

class AnnouncementNotifier extends BaseNotifier {
  Future<ResultModel> announcements({
    required url,
  }) async {
    return await announcementApi.announcements(url);
  }

  void announcementGet({
    required url,
    required id,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await announcementApi.announcementGet(url, id);
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
    required url,
    required content,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await announcementApi.announcementAdd(url, content);
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
    required url,
    required id,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      result = await announcementApi.announcementDel(url, id);
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
