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

  Future<ResultModel> dirAction({
    required url,
    required dirName,
    required parentID,
    required id,
  }) async {
    return await dirApi.dirAction(url, dirName, parentID, id);
  }

  Future<ResultModel> dirInfo({
    required url,
    required id,
  }) async {
    return await dirApi.dirInfo(url, id);
  }

  Future<ResultModel> dirDel({
    required url,
    required id,
  }) async {
    return await dirApi.dirDel(url, id);
  }
}
