import 'dart:io';

import 'package:admin/app/common/appformfield.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/fileupload_controller.dart';

enum UploadType { image, all }

class FileuploadView extends GetView<FileuploadController> {
  const FileuploadView({super.key, this.uploadType = UploadType.all});

  final UploadType uploadType;

  @override
  Widget build(BuildContext context) {
    Get.put<FileuploadController>(FileuploadController());
    return switch (uploadType) {
      UploadType.image => Center(
        child: GetBuilder<FileuploadController>(
          builder: (_) {
            return Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: controller.selectedFile == null
                    ? null
                    : DecorationImage(
                        image: FileImage(controller.convertselectedFile!),
                        fit: BoxFit.cover,
                      ),
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: controller.selectedFile != null
                  ? null
                  : IconButton(
                      icon: Icon(
                        FluentIcons.arrow_upload_16_filled,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () =>
                          controller.pickBottomSheet(multipe: false),
                    ),
            );
          },
        ),
      ),

      _ => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          AppLabel(label: "Ressources/Gallery"),
          Container(
            height: 60,
            width: Get.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton.icon(
              label: GetBuilder<FileuploadController>(
                builder: (_) {
                  return Text(
                    controller.selectedFiles.isEmpty
                        ? 'Select Files'
                        : '${controller.selectedFiles.length} files selected',
                    style: TextStyle(color: Colors.grey.shade600),
                  );
                },
              ),
              icon: Icon(
                FluentIcons.arrow_upload_16_filled,
                color: Colors.grey.shade600,
              ),
              onPressed: () => controller.pickBottomSheet(multipe: true),
            ),
          ),
          GetBuilder<FileuploadController>(
            builder: (_) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: List.generate(
                  controller.img.length,
                  (int i) => GestureDetector(
                    onTap: () => Get.bottomSheet(
                      SizedBox(
                        width: Get.width,
                        height: Get.height * 0.15,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              label: Text("See in full screen"),
                              icon: Icon(
                                FluentIcons.full_screen_maximize_16_filled,
                              ),
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () => controller.removePickedFile(
                                uploadType,
                                controller.img[i],
                              ),
                              label: Text("Remove"),
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                      isScrollControlled: false,
                      backgroundColor: Colors.white,
                    ),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(controller.img[i].path!)),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          GetBuilder<FileuploadController>(
            builder: (_) {
              return Column(
                spacing: 8,
                children: List.generate(
                  controller.doc.length,
                  (int i) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    width: Get.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(
                          FluentIcons.document_24_regular,
                          color: Colors.grey.shade600,
                        ),
                        Text(controller.doc[i].name),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    };
  }
}
