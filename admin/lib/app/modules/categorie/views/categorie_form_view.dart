import 'package:admin/app/common/fileupload/views/fileupload_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/appformfield.dart';
import '../controllers/categorie_form_controller.dart';

class CategorieFormView extends GetView<CategorieFormController> {
  const CategorieFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('add categorie')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.catFormKey,
          child: Column(
            spacing: 20,
            children: [
              FileuploadView(uploadType: UploadType.image),
              AppFormField.label(
                label: "Category Name",
                hint: "Enter category name",
                ctr: controller.nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              AppFormField.label(
                label: "Description",
                hint: "Enter category description",
                minLines: 3,
                ctr: controller.descController,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: controller.craeteCategory,
                child: const Text("Add Category"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
