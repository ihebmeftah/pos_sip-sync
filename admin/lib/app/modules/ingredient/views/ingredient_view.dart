import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../themes/apptheme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/ingredient_controller.dart';

class IngredientView extends GetView<IngredientController> {
  const IngredientView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredients'),
        actions: [
          IconButton(
            color: Colors.grey.shade300,
            onPressed: () {
              Get.toNamed(Routes.INGREDIENT_FORM);
            },
            style: IconButton.styleFrom(backgroundColor: AppTheme().primary),
            icon: const Icon(FluentIcons.add_12_filled),
          ),
        ],
      ),
      body: controller.obx(
        (s) => ListView.builder(
          itemCount: controller.ingredients.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(controller.ingredients[index].name),
              subtitle: Text(
                'Qte: ${controller.ingredients[index].currentStock} ${controller.ingredients[index].stockUnit.name}',
              ),
            );
          },
        ),
        onEmpty: const Center(child: Text('No ingredients found')),
        onError: (error) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
