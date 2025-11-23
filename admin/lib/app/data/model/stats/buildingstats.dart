import 'package:admin/app/data/model/article/article.dart';
import 'package:admin/app/data/model/categorie/categorie.dart';
import 'package:json_annotation/json_annotation.dart';
part 'buildingstats.g.dart';

@JsonSerializable()
class BuildingStats {
  int? totalOrders;
  int? totalArticles;
  int? totalCategories;
  int? paidOrders;
  int? totalItemsSold;
  Funds? funds;
  List<MostPopularArticle>? mostPopularArticles;
  List<MostPopularCategory>? mostPopularCategories;

  BuildingStats({
    this.totalOrders,
    this.totalArticles,
    this.totalCategories,
    this.paidOrders,
    this.totalItemsSold,
    this.funds,
    this.mostPopularArticles,
    this.mostPopularCategories,
  });

  factory BuildingStats.fromJson(Map<String, dynamic> json) =>
      _$BuildingStatsFromJson(json);

  Map<String, dynamic> toJson() => _$BuildingStatsToJson(this);
}

@JsonSerializable()
class Funds {
  double? totalSales;
  double? avgOrderValue;

  Funds({this.totalSales, this.avgOrderValue});

  factory Funds.fromJson(Map<String, dynamic> json) => _$FundsFromJson(json);

  Map<String, dynamic> toJson() => _$FundsToJson(this);
}

@JsonSerializable()
class MostPopularArticle {
  Article? article;
  int? count;

  MostPopularArticle({this.article, this.count});

  factory MostPopularArticle.fromJson(Map<String, dynamic> json) =>
      _$MostPopularArticleFromJson(json);

  Map<String, dynamic> toJson() => _$MostPopularArticleToJson(this);
}

@JsonSerializable()
class MostPopularCategory {
  Categorie? category;
  int? count;

  MostPopularCategory({this.category, this.count});

  factory MostPopularCategory.fromJson(Map<String, dynamic> json) =>
      _$MostPopularCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MostPopularCategoryToJson(this);
}
