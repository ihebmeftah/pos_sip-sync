import 'package:admin/app/data/apis/buildings_api.dart';
import 'package:admin/app/data/model/building/building.dart';
import 'package:get/get.dart';

class BuildingsController extends GetxController
    with StateMixin<List<Building>> {
  final buildings = <Building>[].obs;
  @override
  void onInit() async {
    await getBuilding();
    change(buildings, status: RxStatus.success());
    super.onInit();
  }

  Future getBuilding() async {
    try {
      buildings(await BuildingsApi().getBuildings());
    } catch (e) {
      change(null, status: RxStatus.error('Failed to load buildings'));
    }
  }


}
