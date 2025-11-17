import 'package:admin/app/modules/auth/controllers/auth_controller.dart';
import 'package:admin/app/modules/auth/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class MockAuthController extends GetxController
    with Mock, StateMixin
    implements AuthController {
  @override
  final formKey = GlobalKey<FormState>();

  @override
  final emailController = TextEditingController();

  @override
  final passwordController = TextEditingController();

  @override
  bool rememberMe = false;

  @override
  bool obscurePassword = true;

  MockAuthController() {
    change(null, status: RxStatus.success());
  }

  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  @override
  void toggleObscurePwd() {
    obscurePassword = !obscurePassword;
    update(['obscurePassword']);
  }

  @override
  void toggleRemebreMe() {
    rememberMe = !rememberMe;
    update(['rememberMe']);
  }

  @override
  void onLogin() async {
    // Mock implementation - do nothing or call mock
  }
}

class MockRegisterController extends GetxController
    with Mock, StateMixin
    implements RegisterController {
  @override
  final formKey = GlobalKey<FormState>();

  @override
  final TextEditingController fName = TextEditingController();

  @override
  final TextEditingController lName = TextEditingController();

  @override
  final TextEditingController email = TextEditingController();

  @override
  final TextEditingController phone = TextEditingController();

  @override
  final TextEditingController password = TextEditingController();

  @override
  final TextEditingController cpassword = TextEditingController();

  @override
  bool obscurePassword = true;

  MockRegisterController() {
    change(null, status: RxStatus.success());
  }

  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  @override
  void toggleObscurePwd() {
    obscurePassword = !obscurePassword;
    update(['obscurePassword']);
  }

  @override
  void onRegister() async {
    // Mock implementation - do nothing or call mock
  }
}
