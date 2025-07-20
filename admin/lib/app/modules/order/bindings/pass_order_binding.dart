import 'package:get/get.dart';

import '../controllers/pass_order_controller.dart';

class PassOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassOrderController>(
      () => PassOrderController(),
    );
  }
}
