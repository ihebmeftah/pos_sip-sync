import 'dart:developer';

import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/data/model/article/article.dart';
import 'package:admin/app/data/model/table/tables.dart';
import 'package:admin/app/modules/order/controllers/order_controller.dart';
import 'package:admin/app/modules/tables/controllers/tables_controller.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:get/get.dart';

import '../../../data/apis/order_api.dart';
import '../../../data/model/enums/table_status.dart';
import '../../../data/model/order/order.dart';

class PassOrderController extends GetxController with StateMixin {
  Table? table;
  Order? currOrder;
  List<Article> selectedArticles = <Article>[];
  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
  }

  void setTable([Table? t]) async {
    if (t == table || t == null) {
      table = null;
      if (currOrder != null) currOrder = null;
      selectedArticles.clear();
      update(['table', 'selectedArticles']);
      change(null, status: RxStatus.empty());
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }
      return;
    }
    if (t.status == TableStatus.occupied) await getCurrOrderOfTable(t.id);
    table = t;
    update(['table']);
    change(null, status: RxStatus.success());
  }

  Future<void> getCurrOrderOfTable(String tableid) async {
    try {
      currOrder = await OrderApi().getCurrOrderOfTable(tableid);
    } catch (e) {
      log("Error fetching current order for table $tableid: $e");
    }
  }

  void addArticle(Article article) {
    selectedArticles.add(article);
    _updateSelectedArticleWithOcc();
    update(['selectedArticles', article.id]);
  }

  void removeArticle(Article article) {
    final first = selectedArticles.indexWhere((a) => a.id == article.id);
    selectedArticles.removeAt(first);
    _updateSelectedArticleWithOcc();
    update(['selectedArticles', article.id]);
  }

  void clearAllArticles() {
    selectedArticles.clear();
    _updateSelectedArticleWithOcc();
    update(['selectedArticles']);
  }

  void reset() {
    table = null;
    currOrder = null;
    selectedArticles.clear();
    change(null, status: RxStatus.empty());
    update(['table', 'selectedArticles']);
  }

  void passOrder() async {
    try {
      if (currOrder == null && table!.status == TableStatus.available) {
        await createOrder();
      } else {
        if (LocalStorage().building!.tableMultiOrder == true) {
          await createOrder();
        } else {
          await appendItemToOrder();
        }
      }
      Get.find<OrderController>().onInit();
      reset();
    } on ConflictException {
      Get.snackbar(
        "Conflict",
        "Table is already have an order , you can append other items to it or pass new order to another table",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.brown,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pass order",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> createOrder() async {
    try {
      //? Create new order when tabe available
      final passedOrder = await OrderApi().passOrder(
        tableId: table!.id,
        articlesIds: selectedArticles.map((a) => a.id).toList(),
      );
      Get.find<TablesController>().updateTable(passedOrder.table);
      Get.offAndToNamed("${Routes.ORDER_DETAILS}/${passedOrder.id!}");
      Get.snackbar(
        "Success",
        "Order passed successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> appendItemToOrder() async {
    try {
      //? Create add new item when tabe occupied and have order
      await OrderApi().addItemsToOrder(
        orderId: currOrder!.id!,
        articlesIds: selectedArticles.map((a) => a.id).toList(),
      );
      Get.offAndToNamed("${Routes.ORDER_DETAILS}/${currOrder!.id!}");
      Get.snackbar(
        "Success",
        "New items added to order successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      rethrow;
    }
  }

  int countArticleOcc(String articleId) {
    return selectedArticles.where((a) => a.id == articleId).length;
  }

  bool existeArticle(String articleId) {
    return selectedArticles.any((a) => a.id == articleId);
  }

  List<({Article article, int occurrence})> selectedArticleWithOcc = [];

  void _updateSelectedArticleWithOcc() {
    final Map<String, int> occMap = {};
    for (var article in selectedArticles) {
      occMap[article.id] = (occMap[article.id] ?? 0) + 1;
    }
    selectedArticleWithOcc = occMap.entries.map((entry) {
      final article = selectedArticles.firstWhere((a) => a.id == entry.key);
      return (article: article, occurrence: entry.value);
    }).toList();
  }
}
