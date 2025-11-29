import 'package:admin/app/data/model/enums/units_type.dart';
import 'package:admin/app/data/model/ingredient/ingredient.dart';
import 'package:admin/app/modules/ingredient/controllers/ingredient_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/apis/ingredient_api.dart';

class IngredientFormController extends GetxController with StateMixin {
  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  final String? id = Get.parameters['id'];
  final ingFormKey = GlobalKey<FormState>();
  final name = TextEditingController(),
      desc = TextEditingController(),
      currentStock = TextEditingController(),
      minimumStock = TextEditingController();
  UnitsType? selectedUnit;

  void selectUnit(UnitsType? unit) {
    selectedUnit = unit;
  }

  Ingredient get ingredientDto => Ingredient(
    id: id ?? '',
    name: name.text,
    description: desc.text.isNotEmpty ? desc.text : null,
    stockUnit: selectedUnit!,
    currentStock: num.parse(currentStock.text),
    minimumStock: minimumStock.text.isNotEmpty
        ? num.parse(minimumStock.text)
        : null,
  );

  void createIngredient() async {
    try {
      change(null, status: RxStatus.loading());
      await IngredientApi().createIngredient(ingredientDto);
      await Get.find<IngredientController>().getIngredients();
      Get.back();
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
