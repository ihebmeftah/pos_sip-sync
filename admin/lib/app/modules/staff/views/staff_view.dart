import 'package:admin/app/common/appemptyscreen.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/staff_controller.dart';

class StaffView extends GetView<StaffController> {
  const StaffView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.STAFF_FORM),
        child: const Icon(Icons.add),
      ),
      body: controller.obx(
        (state) => ListView.builder(
          itemCount: controller.employers.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                '${controller.employers[index].user.firstname} ${controller.employers[index].user.lastname}',
              ),
              subtitle: Text(controller.employers[index].buildingEmail),
            );
          },
        ),
        onEmpty: Appemptyscreen(),
      ),
    );
  }
}
