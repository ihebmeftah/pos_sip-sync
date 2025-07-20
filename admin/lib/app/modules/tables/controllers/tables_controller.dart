import 'package:admin/app/data/apis/tables_api.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../../../data/model/enums/table_status.dart';
import '../../../data/model/table/tables.dart';

class TablesController extends GetxController with StateMixin {
  final tables = <Table>[].obs;
  int get availableNb =>
      tables.where((table) => table.status == TableStatus.available).length;
  int get occupiedNb =>
      tables.where((table) => table.status == TableStatus.occupied).length;

  @override
  void onInit() {
    getTabels();
    super.onInit();
  }

  Future getTabels() async {
    try {
      tables(
        await TablesApi().getTables(
          status: Get.previousRoute == Routes.PASS_ORDER
              ? TableStatus.available
              : null,
        ),
      );
      if (tables.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(tables, status: RxStatus.success());
      }
    } catch (e) {
      change([], status: RxStatus.error('Failed to load tables'));
    }
  }

  void updateTable(Table table) {
    final index = tables.indexWhere((t) => t.id == table.id);
    if (index != -1) {
      tables[index] = table;
      update([table.id]);
    }
  }
}
