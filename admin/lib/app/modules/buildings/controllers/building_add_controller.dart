import 'package:admin/app/common/fileupload/controllers/fileupload_controller.dart';
import 'package:admin/app/data/apis/buildings_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/building/building.dart';
import 'buildings_controller.dart';

class BuildingAddController extends GetxController {
  final addFormkey = GlobalKey<FormState>();

  final name = TextEditingController(),
      location = TextEditingController(),
      opening = TextEditingController(
        text: TimeOfDay(hour: 07, minute: 00).format(Get.context!),
      ),
      closing = TextEditingController(
        text: TimeOfDay(hour: 23, minute: 00).format(Get.context!),
      );

  Building get addDto => Building(
    name: name.text,
    location: location.text,
    openingTime: opening.text,
    closingTime: closing.text,
  );
  Future<void> addBuilding() async {
    try {
      if (addFormkey.currentState!.validate()) {
        await BuildingsApi().createBuilding(
          addDto,
          logo: Get.find<FileuploadController>().convertselectedFile,
          photos: Get.find<FileuploadController>().convertselectedFiles,
        );
        Get.find<BuildingsController>().onInit();
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add building: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void pickOpeningTime() async {
    final time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay(hour: 07, minute: 00),
    );
    if (time != null) {
      opening.text = time.format(Get.context!);
    }
  }

  void pickClosingTime() async {
    final time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay(hour: 23, minute: 00),
    );
    if (time != null) {
      closing.text = time.format(Get.context!);
    }
  }
}
