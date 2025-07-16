import 'dart:io';

import 'package:admin/app/common/fileupload/views/fileupload_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Allowed image file extensions
final imgExt = ['jpg', 'jpeg', 'png'];
final docExt = ['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx'];

class FileuploadController extends GetxController {
  List<PlatformFile> selectedFiles = [];
  PlatformFile? selectedFile;
  List<PlatformFile> get img => selectedFiles
      .where((file) => imgExt.contains(file.extension?.toLowerCase()))
      .toList();

  List<PlatformFile> get doc => selectedFiles
      .where((file) => docExt.contains(file.extension?.toLowerCase()))
      .toList();
  void _selection({bool multipe = false, FileType type = FileType.any}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: multipe,
        type: type,
      );
      if (result != null) {
        if (multipe) {
          selectedFiles.addAll(result.files);
        } else {
          selectedFile = result.files.first; // For single file selection
        }
        update(); // Notify listeners about the change
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick files: $e');
    }
  }

  pickBottomSheet({required bool multipe}) => Get.bottomSheet(
    Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Select Image'),
            onTap: () {
              Get.back();
              _selection(multipe: multipe, type: FileType.image);
            },
          ),
          /*   ListTile(
            leading: Icon(Icons.document_scanner),
            title: Text('Select Document'),
            onTap: () {
              Get.back();
              _selection(multipe: multipe, type: FileType.any);
            },
          ), */
        ],
      ),
    ),
    isScrollControlled: false,
    backgroundColor: Colors.white,
  );

  File? get convertselectedFile =>
      selectedFile?.path != null ? File(selectedFile!.path!) : null;
  List<File> get convertselectedFiles => selectedFiles.isEmpty
      ? []
      : selectedFiles.map((file) => File(file.path!)).toList();

  removePickedFile(UploadType type, PlatformFile file) {
    if (type == UploadType.image) {
      selectedFile = null;
    } else {
      selectedFiles.remove(file);
    }
    Get.back();
    update();
  }
}
