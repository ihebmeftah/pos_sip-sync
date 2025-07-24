import '../model/history/history.dart';
import 'htthp_helper.dart';

class HistoryApi {
  Future<List<History>> getOrderHistory(String orderId) async {
    return await HttpHelper.get<List<History>>(
      endpoint: '/order/$orderId/history',
      fromJson: (json) => (json as List)
          .map((e) => History.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
