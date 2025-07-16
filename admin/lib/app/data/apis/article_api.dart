import 'dart:io';

import 'package:admin/app/data/model/article/article.dart';
import 'htthp_helper.dart';

class ArticleApi {
  Future<List<Article>> getArticle() async {
    return await HttpHelper.get<List<Article>>(
      endpoint: '/article',
      fromJson: (data) {
        return (data as List)
            .map((e) => Article.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }


  Future<List<Article>> getArticleByCategoryId(String categoryId) async {
    return await HttpHelper.get<List<Article>>(
      endpoint: '/article/category/$categoryId',
      fromJson: (data) {
        return (data as List)
            .map((e) => Article.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<Article> createArticle(Article article, {required File? image}) async {
    return await HttpHelper.post<Article>(
      endpoint: '/article',
      body: article.addtoJson(),
      files: [SingleFile(key: 'image', file: image)],
      fromJson: (data) {
        return Article.fromJson(data);
      },
    );
  }
}
