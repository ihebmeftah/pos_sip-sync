import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/data/apis/categories_api.dart';
import 'package:admin/app/data/model/categorie/categorie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorieController extends GetxController
    with StateMixin<List<Categorie>> {
  final categories = <Categorie>[].obs;
  @override
  void onInit() {
    getCategories();
    super.onInit();
  }

  Future getCategories() async {
    try {
      categories(await CategoriesApi().getCategories());
      if (categories.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(categories, status: RxStatus.success());
      }
    } on ConflictException {
      Get.snackbar(
        "Error",
        "Category with this name already exists.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      change([], status: RxStatus.error('Failed to load categories'));
    }
  }
}
