import 'package:admin/app/common/appdropdown.dart';
import 'package:admin/app/data/model/categorie/categorie.dart';
import 'package:admin/app/modules/categorie/controllers/categorie_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/appformfield.dart';
import '../../../common/fileupload/views/fileupload_view.dart';
import '../controllers/article_form_controller.dart';

class ArticleFormView extends GetView<ArticleFormController> {
  const ArticleFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('add article')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.artFormKey,
          child: Column(
            spacing: 20,
            children: [
              FileuploadView(uploadType: UploadType.image),
              AppFormField.label(
                label: "Article Name",
                hint: "Enter article name",
                ctr: controller.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    flex: 2,
                    child: GetX<CategorieController>(
                      init: CategorieController(),
                      builder: (catCtr) {
                        return AppDropdown<Categorie>.label(
                          selectedItem: controller.selectedCategory,
                          onChanged: controller.selectCategorie,
                          label: "Category",
                          hint: "Select article category",
                          items: catCtr.categories
                              .map(
                                (e) => DropdownMenuItem<Categorie>(
                                  value: e,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return "Category is required";
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: AppFormField.label(
                      label: "Price",
                      hint: "Enter article price",
                      ctr: controller.price,
                      isNumeric: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Price is required";
                        }
                        if (!GetUtils.isNum(value)) {
                          return "Price must be a number";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              AppFormField.label(
                label: "Description",
                hint: "Enter article description",
                minLines: 3,
                ctr: controller.description,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: controller.createArticle,
                child: const Text("Add Article"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
