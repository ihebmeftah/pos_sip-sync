import 'package:admin/app/data/model/table/tables.dart';
import 'package:admin/app/modules/order/controllers/pass_order_controller.dart';
import 'package:get/get.dart';

import '../../../data/apis/tables_api.dart';
import '../../../routes/app_pages.dart';

class QrscanController extends GetxController {
  void onQRViewCreated(dynamic controller) {
    controller.scannedDataStream.listen((scanData) async {
      try {
        final allowed = RegExp(
          r'^([^.]+)\.([^.]+)\.([^.]+)\@([^.]+)\.([^.]+)\.([^.]+)\$',
        );
        Get.back();
        if (allowed.hasMatch(scanData.code)) {
          Table table = await TablesApi().scanTable(
            id: (scanData.code as String).split('@').first,
          );
          Get.find<PassOrderController>().setTable(table);
          Get.toNamed(Routes.PASS_ORDER);
        } else {
          print('Invalid QR code');
        }
      } catch (e) {
        Get.back();
        print('Error scanning QR code: $e');
      } finally {
        controller.dispose();
      }
    });
  }
}
