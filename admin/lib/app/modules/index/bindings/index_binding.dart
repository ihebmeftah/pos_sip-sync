import 'package:admin/app/modules/order/controllers/pass_order_controller.dart';
import 'package:get/get.dart';

import '../controllers/index_controller.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndexController>(() => IndexController());
    Get.put<PassOrderController>(PassOrderController());
  }
}
