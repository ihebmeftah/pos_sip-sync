import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/data/apis/buildings_api.dart';
import 'package:admin/app/data/model/building/building.dart';
import 'package:get/get.dart';

class BuildingsController extends GetxController
    with StateMixin<List<Building>> {
  final buildings = <Building>[].obs;
  @override
  void onInit() async {
    await getBuilding();
    super.onInit();
  }

  Future getBuilding() async {
    try {
      buildings(await BuildingsApi().getBuildings());
      if (buildings.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(buildings, status: RxStatus.success());
      }
    } on ForrbidenException {
      change(null, status: RxStatus.error('🚨 Access denied'));
    } catch (e) {
      change(null, status: RxStatus.error('Failed to load buildings'));
    }
  }
}
