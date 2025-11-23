import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/data/model/employer/employer.dart';
import 'package:get/get.dart';

import '../../../data/apis/staff_api.dart';

class StaffDetailsController extends GetxController with StateMixin {
  Employer? employer;
  String? id = Get.parameters['id'];

  @override
  void onInit() {
    getEmployerById();
    super.onInit();
  }

  Future<void> getEmployerById([String? id]) async {
    try {
      if (id != null || this.id != null) {
        employer = await StaffApi().getEmployerById(id ?? this.id!);
        await LocalStorage().saveBuilding(employer!.building!);
        change(employer, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load employer details');
    }
  }
}
