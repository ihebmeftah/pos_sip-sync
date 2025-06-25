import 'package:admin/app/data/model/article/article.dart';
import 'htthp_helper.dart';

class ArticleApi {
  Future<List<Article>> getArticle() {
    return HttpHelper.get<List<Article>>(
      endpoint: '/article',
      fromJson: (data) {
        return (data as List)
            .map((e) => Article.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
