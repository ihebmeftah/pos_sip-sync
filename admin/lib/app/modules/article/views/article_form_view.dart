import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/article_form_controller.dart';

class ArticleFormView extends GetView<ArticleFormController> {
  const ArticleFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArticleFormView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ArticleFormView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
