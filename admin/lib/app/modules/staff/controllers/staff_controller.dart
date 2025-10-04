import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/data/model/employer/employer.dart';
import 'package:get/get.dart';

import '../../../data/apis/staff_api.dart';

class StaffController extends GetxController with StateMixin<List<Employer>> {
  final employers = <Employer>[].obs;

  @override
  void onInit() {
    super.onInit();
    getEmployers();
  }

  void getEmployers() async {
    try {
      employers(await StaffApi().getEmployers());
      if (employers.isNotEmpty) {
        change(employers, status: RxStatus.success());
      } else {
        change([], status: RxStatus.empty());
      }
    } on BadRequestException {
      Get.snackbar('Error', 'Please check your form inputs and try again.');
    } catch (e) {
      change([], status: RxStatus.error('Failed to load employers: $e'));
    }
  }
}
