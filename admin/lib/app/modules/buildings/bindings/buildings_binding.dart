import 'package:get/get.dart';

import '../controllers/buildings_controller.dart';

class BuildingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuildingsController>(
      () => BuildingsController(),
    );
  }
}
