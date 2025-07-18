import 'package:admin/app/common/appemptyscreen.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/themes/apptheme.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/article_controller.dart';

class ArticleView extends GetView<ArticleController> {
  const ArticleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        actions: [
          IconButton(
            color: Colors.grey.shade300,
            onPressed: () {
              Get.toNamed(Routes.ARTICLE_FORM);
            },
            style: IconButton.styleFrom(backgroundColor: AppTheme().primary),
            icon: const Icon(FluentIcons.add_12_filled),
          ),
        ],
      ),
      body: controller.obx(
        (state) => ListView.separated(
          itemCount: controller.articles.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) => Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.all(15),
            child: Row(
              spacing: 15,
              children: [
                Badge(
                  label: Text("2", style: TextStyle(fontSize: 18)),
                  child: IconButton(
                    style: IconButton.styleFrom(iconSize: 18),
                    onPressed: () {},
                    icon: const Icon(FluentIcons.add_12_filled),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                    image: controller.articles[index].image == null
                        ? null
                        : DecorationImage(
                            image: NetworkImage(
                              "http://localhost:3000/${controller.articles[index].image!}",
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: controller.articles[index].image != null
                      ? null
                      : Text(
                          controller.articles[index].name
                              .substring(0, 1)
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        controller.articles[index].name.capitalizeFirst!,
                        style: context.theme.textTheme.titleMedium,
                      ),
                      Text(
                        controller.articles[index].categorie.name,
                        style: context.theme.textTheme.labelLarge!.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${controller.articles[index].price} DT",
                  style: context.theme.textTheme.titleLarge,
                ),
                Switch(value: true, onChanged: (value) {}),
              ],
            ),
          ),
        ),
        onEmpty: Appemptyscreen(),
      ),
    );
  }
}
