import 'package:admin/app/common/fileupload/controllers/fileupload_controller.dart';
import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/data/model/enums/user_role.dart';
import 'package:admin/app/data/model/user/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/apis/staff_api.dart';
import 'staff_controller.dart';

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
    type: UserType.employer,
  );

  void createEmployyer() async {
    try {
      if (formKey.currentState!.validate()) {
        final employer = await StaffApi().addStaff(
          dto,
          Get.find<FileuploadController>().convertselectedFile,
        );
        Get.find<StaffController>().getEmployers();
        Get.back(result: employer);
        Get.snackbar('Success', 'Employer created successfully');
      }
    } on ConflictException {
      Get.snackbar(
        'Error',
        'An employer with this email or phone already exists.',
      );
    } on BadRequestException {
      Get.snackbar('Error', 'Please check your form inputs and try again.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create employer: $e');
    }
  }
}
