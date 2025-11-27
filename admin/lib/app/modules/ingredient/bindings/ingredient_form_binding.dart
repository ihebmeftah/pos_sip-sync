import 'package:get/get.dart';

import '../controllers/ingredient_form_controller.dart';

class IngredientFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IngredientFormController>(
      () => IngredientFormController(),
    );
  }
}
