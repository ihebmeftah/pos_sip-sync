import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/data/model/employer/employer.dart';
import 'package:get/get.dart';

import '../../../data/apis/staff_api.dart';

class StaffDetailsController extends GetxController {
  Employer? employer;
  String? id = Get.parameters['id'];

  Future<void> getEmployerById([String? id]) async {
    try {
      if (id != null || this.id != null) {
        employer = await StaffApi().getEmployerById(id ?? this.id!);
        await LocalStorage().saveBuilding(employer!.building!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load employer details');
    }
  }
}
