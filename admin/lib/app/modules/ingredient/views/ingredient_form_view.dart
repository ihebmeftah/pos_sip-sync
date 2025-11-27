import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ingredient_form_controller.dart';

class IngredientFormView extends GetView<IngredientFormController> {
  const IngredientFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IngredientFormView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'IngredientFormView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
