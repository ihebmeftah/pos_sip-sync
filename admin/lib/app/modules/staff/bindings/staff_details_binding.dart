import 'package:get/get.dart';

import '../controllers/staff_details_controller.dart';

class StaffDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaffDetailsController>(
      () => StaffDetailsController(),
    );
  }
}
