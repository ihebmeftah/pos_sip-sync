import 'package:get/get.dart';

import '../controllers/categorie_controller.dart';

class CategorieBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategorieController>(
      () => CategorieController(),
    );
  }
}
