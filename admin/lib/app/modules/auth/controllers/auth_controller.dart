import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/data/apis/auth_api.dart';
import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/data/model/building/building.dart';
import 'package:admin/app/data/model/enums/user_role.dart';
import 'package:admin/app/data/model/user/login_user.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController with StateMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  bool obscurePassword = true;

  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  void onLogin() async {
    try {
      if (formKey.currentState!.validate()) {
        change(null, status: RxStatus.loading());
        final user = await AuthApi().login(
          identifier: emailController.text,
          password: passwordController.text,
        );
        final LoginUser loginuser = LoginUser.fromJson(user);
        await LocalStorage().saveUser(loginuser);
        if (loginuser.type == UserType.employer) {
          final Building building = Building.fromJson(user['building']);
          await LocalStorage().saveBuilding(building);
          Get.offAllNamed(Routes.INDEX);
        } else {
          Get.offAllNamed(Routes.BUILDINGS);
        }
        change(null, status: RxStatus.success());
      }
    } on AuthException {
      Get.snackbar(
        'Error',
        'May be email or password is incorrect ',
        backgroundColor: Colors.red,
      );
    }
  }

  void toggleObscurePwd() {
    obscurePassword = !obscurePassword;
    update(['obscurePassword']);
  }

  void toggleRemebreMe() {
    rememberMe = !rememberMe;
    update(['rememberMe']);
  }
}
