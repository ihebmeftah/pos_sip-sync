import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ingredient_controller.dart';

class IngredientView extends GetView<IngredientController> {
  const IngredientView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IngredientView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'IngredientView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
