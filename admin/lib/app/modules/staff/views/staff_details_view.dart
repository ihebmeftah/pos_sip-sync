import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/staff_details_controller.dart';

class StaffDetailsView extends GetView<StaffDetailsController> {
  const StaffDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StaffDetailsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StaffDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
