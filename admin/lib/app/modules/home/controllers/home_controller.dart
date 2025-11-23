import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/data/model/article/article.dart';
import 'package:admin/app/data/model/categorie/categorie.dart';
import 'package:admin/app/data/model/stats/buildingstats.dart';
import 'package:admin/app/data/model/user/login_user.dart';
import 'package:get/get.dart';

import '../../../data/apis/stats_api.dart';

class HomeController extends GetxController with StateMixin {
  LoginUser loggedUser = LocalStorage().user!;

  late BuildingStats? buildingStats;

  // Computed properties from buildingStats
  double get totalRevenue => buildingStats?.funds?.totalSales ?? 0.0;
  double get avgOrderValue => buildingStats?.funds?.avgOrderValue ?? 0.0;
  int get totalOrders => buildingStats?.totalOrders ?? 0;
  int get paidOrders => buildingStats?.paidOrders ?? 0;
  int get totalArticles => buildingStats?.totalArticles ?? 0;
  int get totalCategories => buildingStats?.totalCategories ?? 0;
  int get totalItemsSold => buildingStats?.totalItemsSold ?? 0;

  List<MapEntry<Article, int>> get topArticles {
    if (buildingStats?.mostPopularArticles == null) return [];
    return buildingStats!.mostPopularArticles!
        .where((item) => item.article != null)
        .map((item) => MapEntry(item.article!, item.count ?? 0))
        .toList();
  }

  List<MapEntry<Categorie, int>> get topCategories {
    if (buildingStats?.mostPopularCategories == null) return [];
    return buildingStats!.mostPopularCategories!
        .where((item) => item.category != null)
        .map((item) => MapEntry(item.category!, item.count ?? 0))
        .toList();
  }

  @override
  void onInit() {
    getStats();
    super.onInit();
  }

  Future<void> getStats() async {
    try {
      buildingStats = await StatsApi.getStats();
      if (buildingStats == null) {
        change(null, status: RxStatus.empty());
      } else {
        change(buildingStats, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
