import 'package:admin/app/data/apis/categories_api.dart';
import 'package:admin/app/modules/categorie/controllers/categorie_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/fileupload/controllers/fileupload_controller.dart';

class CategorieFormController extends GetxController with StateMixin {
  final catFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  void craeteCategory() async {
    try {
      if (catFormKey.currentState!.validate()) {
        change(null, status: RxStatus.loading());
        await CategoriesApi().createCategories(
          name: nameController.text,
          description: descController.text,
          image: Get.find<FileuploadController>().convertselectedFile,
        );
        Get.find<CategorieController>().getCategories();
        Get.back();
      }
    } catch (e) {
      change(null, status: RxStatus.error("Failed to create Category"));
    }
  }
}
