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
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              color: Colors.white,
              onPressed: () {
                Get.toNamed(Routes.CATEGORIE_FORM);
              },
              style: IconButton.styleFrom(
                backgroundColor: AppTheme().primary,
                padding: const EdgeInsets.all(12),
              ),
              icon: const Icon(FluentIcons.add_12_filled, size: 20),
            ),
          ),
        ],
      ),
      body: controller.obx(
        (state) => Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: state?.length ?? 0,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return GestureDetector(
                onTap: () => Get.toNamed(
                  Routes.ARTICLE,
                  parameters: {'cat': category.id},
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: category.image == null
                        ? null
                        : DecorationImage(
                            image: NetworkImage(category.image!),
                            fit: BoxFit.cover,
                          ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Container
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme().primary.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: category.image != null
                                ? null
                                : Center(
                                    child: Icon(
                                      FluentIcons.grid_24_filled,
                                      size: 48,
                                      color: AppTheme().primary.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      // Content Section
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                category.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: AppTheme().primary,
                              ),
                              onPressed: () =>
                                  Get.toNamed(Routes.CATEGORIE_FORM),
                              icon: Icon(Icons.edit_square),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        onEmpty: const Appemptyscreen(),
      ),
    );
  }
}
