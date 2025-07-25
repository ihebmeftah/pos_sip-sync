import 'package:admin/app/common/fileupload/controllers/fileupload_controller.dart';
import 'package:admin/app/data/model/enums/user_role.dart';
import 'package:admin/app/data/model/user/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/apis/staff_api.dart';

class StaffFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final fname = TextEditingController(),
      lname = TextEditingController(),
      email = TextEditingController(),
      password = TextEditingController(),
      phone = TextEditingController();

  User get dto => User(
    firstname: fname.text,
    lastname: lname.text,
    email: email.text,
    password: password.text,
    phone: phone.text,
    type: [UserType.employer],
  );

  void createEmployyer() async {
    try {
      if (formKey.currentState!.validate()) {
        final employer = await StaffApi().addStaff(
          dto,
          Get.find<FileuploadController>().convertselectedFile!,
        );
        Get.back(result: employer);
        Get.snackbar('Success', 'Employer created successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create employer: $e');
    }
  }
}
