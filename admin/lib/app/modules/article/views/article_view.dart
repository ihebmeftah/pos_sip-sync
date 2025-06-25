import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/article_controller.dart';

class ArticleView extends GetView<ArticleController> {
  const ArticleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: controller.obx(
        (state) => ListView.builder(
          itemCount: controller.articles.length,
          itemBuilder: (context, index) => ListTile(
            leading: Container(
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
            title: Text(controller.articles[index].name),
            subtitle: Text(controller.articles[index].categorie.name),
            
          ),
        ),
      ),
    );
  }
}
