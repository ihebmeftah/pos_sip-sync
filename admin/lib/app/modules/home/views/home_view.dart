import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "${controller.loggedUser.email} / ${controller.loggedUser.phone} / ${controller.loggedUser.username ?? "--"}",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
