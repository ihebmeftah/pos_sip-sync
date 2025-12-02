import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/buildings_controller.dart';

class BuildingsView extends GetView<BuildingsController> {
  const BuildingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuildingsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BuildingsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
