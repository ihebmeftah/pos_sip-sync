import 'package:admin/app/data/model/article/article.dart';
import 'package:get/get.dart';

import '../../../data/apis/article_api.dart';

class ArticleController extends GetxController with StateMixin {
  final articles = <Article>[].obs;
  @override
  void onInit() {
    getArticles();
    super.onInit();
  }

  Future getArticles() async {
    try {
      articles(await ArticleApi().getArticle());
      if (articles.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(articles, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error('Failed to load articles'));
    }
  }
}
