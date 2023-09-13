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
      await announcementApi.announcementGet(url, id).then((value) {
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

  void announcementAdd({
    required url,
    required content,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      await announcementApi.announcementAdd(url, content).then((value) {
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

  void announcementDel({
    required url,
    required id,
  }) async {
    operationStatus.value = OperationStatus.failure;
    try {
      await announcementApi.announcementDel(url, id).then((value) {
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
}
