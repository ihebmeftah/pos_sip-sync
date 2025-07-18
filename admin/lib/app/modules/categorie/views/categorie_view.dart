import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/themes/apptheme.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/appemptyscreen.dart';
import '../controllers/categorie_controller.dart';

class CategorieView extends GetView<CategorieController> {
  const CategorieView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            color: Colors.grey.shade300,
            onPressed: () {
              Get.toNamed(Routes.CATEGORIE_FORM);
            },
            style: IconButton.styleFrom(backgroundColor: AppTheme().primary),
            icon: const Icon(FluentIcons.add_12_filled),
          ),
        ],
      ),
      body: controller.obx(
        (state) => ListView.builder(
          itemCount: state?.length ?? 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(controller.categories[index].name),
              leading: controller.categories[index].image != null
                  ? Image.network(
                      "http://localhost:3000/${controller.categories[index].image!}",
                    )
                  : null,
            );
          },
        ),
        onEmpty: Appemptyscreen(),
      ),
    );
  }
}
