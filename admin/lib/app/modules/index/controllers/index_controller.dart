import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/data/model/enums/user_role.dart';
import 'package:admin/app/modules/order/controllers/order_controller.dart';
import 'package:admin/app/modules/tables/controllers/tables_controller.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndexController extends GetxController {
  final pageVCtr = PageController();
  int currBnb = 0;

  void changeBnbContent(int index) {
    if (index != currBnb) {
      if (LocalStorage().user!.type == UserType.employer && index == 1) {
        Get.toNamed(Routes.QRSCAN);
        return;
      }
      currBnb = index;
      pageVCtr.jumpToPage(index);
      update(["bottomNavigationBar"]);
      if ((LocalStorage().user!.type == UserType.employer && index != 2) ||
          (LocalStorage().user!.type == UserType.admin && index != 3)) {
        Get.delete<TablesController>();
      } else {
        Get.put<TablesController>(TablesController());
      }
      if ((LocalStorage().user!.type == UserType.employer && index != 0) ||
          (LocalStorage().user!.type == UserType.admin && index != 1)) {
        Get.delete<OrderController>();
      } else {
        Get.put<OrderController>(OrderController());
      }
    }
  }
}
