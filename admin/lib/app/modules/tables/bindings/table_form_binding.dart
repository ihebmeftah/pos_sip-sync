import 'package:get/get.dart';

import '../controllers/table_form_controller.dart';

class TableFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TableFormController>(
      () => TableFormController(),
    );
  }
}
