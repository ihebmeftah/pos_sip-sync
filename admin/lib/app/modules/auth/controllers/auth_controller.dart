import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/data/apis/auth_api.dart';
import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/data/model/enums/user_role.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  bool obscurePassword = true;

  void onLogin() async {
    try {
      if (formKey.currentState!.validate()) {
        final user = await AuthApi().login(
          email: emailController.text,
          password: passwordController.text,
        );
        await LocalStorage().saveUser(user);
        if (user.type == UserType.employer) {
          await LocalStorage().saveBuilding(user.building!);
          Get.offAllNamed(Routes.INDEX);
        } else {
          Get.offAllNamed(Routes.BUILDINGS);
        }
      }
    } on UnauthorizedException {
      Get.snackbar(
        'Error',
        'May be email or password is incorrect ',
        backgroundColor: Colors.red,
      );
    }
  }

  toggleObscurePwd() {
    obscurePassword = !obscurePassword;
    update(['obscurePassword']);
  }

  toggleRemebreMe() {
    rememberMe = !rememberMe;
    update(['rememberMe']);
  }
}
