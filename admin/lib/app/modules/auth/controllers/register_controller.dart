import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/data/apis/auth_api.dart';
import 'package:admin/app/data/model/user/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/local/local_storage.dart';
import '../../../data/model/enums/user_role.dart' show UserType;
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fName = TextEditingController();
  final TextEditingController lName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();
  bool obscurePassword = true;
  void toggleObscurePwd() {
    obscurePassword = !obscurePassword;
    update(['obscurePassword']);
  }

  User get user => User(
    firstname: fName.text,
    lastname: lName.text,
    email: email.text,
    phone: phone.text,
    password: password.text,
    type: UserType.admin,
  );
  void onRegister() async {
    try {
      if (formKey.currentState!.validate()) {
        final regUser = await AuthApi().register(user);
        await LocalStorage().saveUser(regUser);
        Get.offAllNamed(Routes.BUILDINGS);
        Get.snackbar(
          'Success',
          'Registration successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back();
      }
    } on ConflictException {
      Get.snackbar(
        'Error',
        'Account with this email or phone already exists',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
