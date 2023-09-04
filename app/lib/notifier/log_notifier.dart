import 'package:app/model/result_model.dart';
import 'package:app/notifier/base_notifier.dart';

class LogNotifier extends BaseNotifier {
  Future<ResultModel> viewLog({
    date,
    account,
  }) async {
    return await logApi.viewLog(date, account);
  }
}
