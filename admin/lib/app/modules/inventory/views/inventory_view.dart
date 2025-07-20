import 'package:admin/app/common/appemptyscreen.dart';
import 'package:admin/app/modules/article/controllers/article_controller.dart';
import 'package:admin/app/modules/categorie/controllers/categorie_controller.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/main.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/inventory_controller.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 10,
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(FluentIcons.search_12_regular),
                hintText: "Search dishes, cafe, etc..",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.CATEGORIE),
                  child: Text("View All"),
                ),
              ],
            ),
            SizedBox(
              height: 40,
              child: GetX<CategorieController>(
                init: CategorieController(),
                builder: (ctr) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctr.categories.length + 1,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) => TextButton.icon(
                      onPressed: () {
                        if (index != 0) return;
                        Get.toNamed(Routes.CATEGORIE_FORM);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: index == 0
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                        foregroundColor: index == 0
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                      ),
                      label: Text(
                        index == 0 ? "Add" : ctr.categories[index - 1].name,
                      ),
                      icon: Icon(
                        index == 0
                            ? FluentIcons.add_12_filled
                            : FluentIcons.tag_16_regular,
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Articles", style: Theme.of(context).textTheme.titleLarge),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.ARTICLE),
                  child: Text("View All"),
                ),
              ],
            ),
            Expanded(
              child: GetX<ArticleController>(
                init: ArticleController(),
                builder: (ctr) {
                  return ctr.articles.isEmpty
                      ? Appemptyscreen(route: Routes.ARTICLE)
                      : ListView.builder(
                          itemCount: ctr.articles.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                                image: ctr.articles[index].image == null
                                    ? null
                                    : DecorationImage(
                                        image: NetworkImage(
                                          "$url${ctr.articles[index].image!}",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              child: ctr.articles[index].image != null
                                  ? null
                                  : Text(
                                      ctr.articles[index].name
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            title: Text(ctr.articles[index].name),
                            subtitle: Text(ctr.articles[index].categorie!.name),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
