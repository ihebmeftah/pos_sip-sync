import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/data/model/enums/user_role.dart';
import 'package:admin/app/modules/order/controllers/order_controller.dart';
import 'package:admin/app/modules/tables/controllers/tables_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/apis/caisse_api.dart';
import '../../../data/model/caisse/caisse.dart';

class IndexController extends GetxController with StateMixin {
  final caisses = <Caisse>[].obs;
  Rxn<Caisse> currentCaisse = Rxn<Caisse>();
  @override
  void onInit() async {
    await createCaisse();
    super.onInit();
  }

  Future<void> getCaisses() async {
    try {
      caisses(await CaisseApi().getCaisse());
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> createCaisse() async {
    try {
      currentCaisse(await CaisseApi().createCaisse());
      if (LocalStorage().user!.type == UserType.admin) {
        await getCaisses();
      } else {
        change(null, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  final pageVCtr = PageController();
  int currBnb = 0;

  void changeBnbContent(int index) {
    if (index != currBnb) {
      if (LocalStorage().user!.type == UserType.employer && index == 1) return;
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
