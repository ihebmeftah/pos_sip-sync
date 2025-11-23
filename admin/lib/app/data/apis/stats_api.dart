import 'package:admin/app/data/apis/htthp_helper.dart';
import 'package:admin/app/data/model/stats/buildingstats.dart';

class StatsApi {
  static Future<BuildingStats?> getStats() async {
    return await HttpHelper.get<BuildingStats?>(
      endpoint: '/stats',
      fromJson: (v) => BuildingStats.fromJson(v),
    );
  }
}
