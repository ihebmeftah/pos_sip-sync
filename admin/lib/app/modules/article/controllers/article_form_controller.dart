import 'dart:developer';

import 'package:admin/app/common/fileupload/controllers/fileupload_controller.dart';
import 'package:admin/app/data/apis/article_api.dart';
import 'package:admin/app/data/model/categorie/categorie.dart';
import 'package:admin/app/modules/article/controllers/article_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/model/article/article.dart';

class ArticleFormController extends GetxController {
  final artFormKey = GlobalKey<FormState>();
  final name = TextEditingController(),
      description = TextEditingController(),
      price = TextEditingController();
  Categorie? selectedCategory;
  Article get articleDto => Article(
    id: '',
    name: name.text,
    description: description.text,
    price: num.parse(price.text),
    categorie: selectedCategory!,
  );
  void createArticle() async {
    try {
      if (artFormKey.currentState!.validate()) {
        await ArticleApi().createArticle(
          articleDto,
          image: Get.find<FileuploadController>().convertselectedFile,
        );
        Get.find<ArticleController>().getArticles();
        Get.back();
      }
    } catch (e) {
      log("Error creating article: $e");
    }
  }

  void selectCategorie(Categorie? category) {
    if (category != null) {
      selectedCategory = category;
    }
  }
}
