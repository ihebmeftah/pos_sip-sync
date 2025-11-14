import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/data/model/table/tables.dart';
import 'package:admin/app/modules/order/controllers/pass_order_controller.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:get/get.dart';

import '../../../data/apis/tables_api.dart';
import '../../../routes/app_pages.dart';

class QrscanController extends GetxController {
  void onQRViewCreated(dynamic controller) {
    controller.scannedDataStream.listen((scanData) async {
      try {
        controller.pauseCamera();
        final allowed = RegExp(
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}@[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
        );
        Get.back();
        if (allowed.hasMatch(scanData.code)) {
          Table table = await TablesApi().scanTable(
            id: (scanData.code as String).split('@').first,
          );
          Get.find<PassOrderController>().setTable(table);
          Get.toNamed(Routes.PASS_ORDER);
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: Text('Invalid QR code scanned.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } on ConflictException {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('This table is already assigned to another order.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
}
