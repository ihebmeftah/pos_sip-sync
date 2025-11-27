import 'package:admin/app/common/fileupload/controllers/fileupload_controller.dart';
import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/data/apis/buildings_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/building/building.dart';
import 'buildings_controller.dart';

class BuildingAddController extends GetxController {
  final addFormkey = GlobalKey<FormState>();
  DateTime openingTime = DateTime.now();
  DateTime closingTime = DateTime.now().add(const Duration(hours: 14));
  late final TextEditingController name;
  late final TextEditingController location;
  late final TextEditingController opening;
  late final TextEditingController closing;
  final BuildingsApi _api;

  BuildingAddController({BuildingsApi? api}) : _api = api ?? BuildingsApi() {
    name = TextEditingController();
    location = TextEditingController();
    opening = TextEditingController(
      text: Get.context != null
          ? TimeOfDay(hour: 07, minute: 00).format(Get.context!)
          : '07:00 AM',
    );
    closing = TextEditingController(
      text: Get.context != null
          ? TimeOfDay(hour: 23, minute: 00).format(Get.context!)
          : '11:00 PM',
    );
  }

  Building get addDto => Building(
    name: name.text,
    location: location.text,
    openingTime: openingTime,
    closingTime: closingTime,
    dbName: name.text.toLowerCase().replaceAll(' ', '_'),
    tableMultiOrder: false,
  );

  Future<void> addBuilding() async {
    try {
      if (addFormkey.currentState!.validate()) {
        await _api.createBuilding(
          addDto,
          logo: Get.find<FileuploadController>().convertselectedFile,
          photos: Get.find<FileuploadController>().convertselectedFiles,
        );
        Get.find<BuildingsController>().onInit();
        Get.back();
      }
    } on ConflictException {
      Get.snackbar(
        "Error",
        "Building with this name already exists.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
      openingTime = DateTime(
        openingTime.year,
        openingTime.month,
        openingTime.day,
        time.hour,
        time.minute,
      );
    }
  }

  void pickClosingTime() async {
    final time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay(hour: 23, minute: 00),
    );
    if (time != null) {
      closing.text = time.format(Get.context!);
      closingTime = DateTime(
        closingTime.year,
        closingTime.month,
        closingTime.day,
        time.hour,
        time.minute,
      );
    }
  }
}
