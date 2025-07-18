import 'package:admin/app/modules/tables/controllers/tables_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/apis/tables_api.dart';

class TableFormController extends GetxController with StateMixin {
  List<CreateTableViewModel> tables = <CreateTableViewModel>[
    CreateTableViewModel(),
  ];
  @override
  void onInit() {
    super.onInit();
    change(tables, status: RxStatus.success());
  }

  void addZone() {
    tables.add(CreateTableViewModel());
    change(tables, status: RxStatus.success());
  }

  void removeZone(int index) {
    if (index >= 0 && index < tables.length) {
      tables.removeAt(index);
      change(tables, status: RxStatus.success());
    }
  }

  Future<void> createTables() async {
    try {
      if (tables.isEmpty) return;
      change(tables, status: RxStatus.loading());
      await Future.forEach(tables, (t) async {
        if (t.tableformKey.currentState!.validate()) {
          await TablesApi().createTabels(
            nbTables: int.parse(t.nb.text),
            seatsMax: int.parse(t.nbSeat.text),
          );
        }
      });
      Get.back();
      Get.find<TablesController>().getTabels();
    } catch (e) {
      change([], status: RxStatus.error('Failed to create tables'));
    }
  }
}

///  ViewModel for creating a table
///  It contains the form key and controllers for table number and number of seats.
///  It also contains methods to increment and decrement the table number and number of seats.
class CreateTableViewModel {
  final tableformKey = GlobalKey<FormState>();
  final nb = TextEditingController(text: "40");
  final nbSeat = TextEditingController(text: '4');

  void incrementNb() {
    int currentNb = int.tryParse(nb.text) ?? 0;
    nb.text = (currentNb + 1).toString();
  }

  void decrementNb() {
    int currentNb = int.tryParse(nb.text) ?? 0;
    if (currentNb > 0) {
      nb.text = (currentNb - 1).toString();
    }
  }

  void incrementNbSeat() {
    int currentNbSeat = int.tryParse(nbSeat.text) ?? 0;
    nbSeat.text = (currentNbSeat + 1).toString();
  }

  void decrementNbSeat() {
    int currentNbSeat = int.tryParse(nbSeat.text) ?? 0;
    if (currentNbSeat > 0) {
      nbSeat.text = (currentNbSeat - 1).toString();
    }
  }
}
