import 'package:admin/app/common/fileupload/views/fileupload_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/appformfield.dart';
import '../controllers/building_add_controller.dart';

class BuildingAddView extends GetView<BuildingAddController> {
  const BuildingAddView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Building View'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: controller.addFormkey,
                child: Column(
                  spacing: 20,
                  children: [
                    FileuploadView(uploadType: UploadType.image),
                    AppFormField.label(
                      label: "Building Name",
                      hint: "Enter building name",
                      ctr: controller.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),
                    AppFormField.label(
                      label: "Building Location",
                      hint: "Enter building location",
                      ctr: controller.location,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Location is required";
                        }
                        return null;
                      },
                    ),
                    Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: AppFormField.label(
                            readOnly: true,
                            onTap: controller.pickOpeningTime,
                            label: "Opening Time",
                            hint: "Pick opening time",
                            ctr: controller.opening,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Opening time is required";
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: AppFormField.label(
                            readOnly: true,
                            onTap: controller.pickClosingTime,
                            label: "Closing Time",
                            hint: "Pick closing time",
                            ctr: controller.closing,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Closing time is required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    FileuploadView(),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ElevatedButton(
              onPressed: controller.addBuilding,
              child: const Text("Add Building"),
            ),
          ),
        ],
      ),
    );
  }
}
