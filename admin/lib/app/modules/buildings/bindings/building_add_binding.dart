import 'package:get/get.dart';

import '../controllers/building_add_controller.dart';

class BuildingAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuildingAddController>(
      () => BuildingAddController(),
    );
  }
}
