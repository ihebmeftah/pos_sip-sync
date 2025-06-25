import 'package:get/get.dart';

import '../controllers/article_form_controller.dart';

class ArticleFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleFormController>(
      () => ArticleFormController(),
    );
  }
}
