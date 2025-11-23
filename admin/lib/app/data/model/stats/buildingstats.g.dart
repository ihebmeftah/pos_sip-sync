// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buildingstats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuildingStats _$BuildingStatsFromJson(Map<String, dynamic> json) =>
    BuildingStats(
      totalOrders: (json['totalOrders'] as num?)?.toInt(),
      totalArticles: (json['totalArticles'] as num?)?.toInt(),
      totalCategories: (json['totalCategories'] as num?)?.toInt(),
      paidOrders: (json['paidOrders'] as num?)?.toInt(),
      totalItemsSold: (json['totalItemsSold'] as num?)?.toInt(),
      funds: json['funds'] == null
          ? null
          : Funds.fromJson(json['funds'] as Map<String, dynamic>),
      mostPopularArticles: (json['mostPopularArticles'] as List<dynamic>?)
          ?.map((e) => MostPopularArticle.fromJson(e as Map<String, dynamic>))
          .toList(),
      mostPopularCategories: (json['mostPopularCategories'] as List<dynamic>?)
          ?.map((e) => MostPopularCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BuildingStatsToJson(BuildingStats instance) =>
    <String, dynamic>{
      'totalOrders': instance.totalOrders,
      'totalArticles': instance.totalArticles,
      'totalCategories': instance.totalCategories,
      'paidOrders': instance.paidOrders,
      'totalItemsSold': instance.totalItemsSold,
      'funds': instance.funds,
      'mostPopularArticles': instance.mostPopularArticles,
      'mostPopularCategories': instance.mostPopularCategories,
    };

Funds _$FundsFromJson(Map<String, dynamic> json) => Funds(
  totalSales: (json['totalSales'] as num?)?.toDouble(),
  avgOrderValue: (json['avgOrderValue'] as num?)?.toDouble(),
);

Map<String, dynamic> _$FundsToJson(Funds instance) => <String, dynamic>{
  'totalSales': instance.totalSales,
  'avgOrderValue': instance.avgOrderValue,
};

MostPopularArticle _$MostPopularArticleFromJson(Map<String, dynamic> json) =>
    MostPopularArticle(
      article: json['article'] == null
          ? null
          : Article.fromJson(json['article'] as Map<String, dynamic>),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MostPopularArticleToJson(MostPopularArticle instance) =>
    <String, dynamic>{'article': instance.article, 'count': instance.count};

MostPopularCategory _$MostPopularCategoryFromJson(Map<String, dynamic> json) =>
    MostPopularCategory(
      category: json['category'] == null
          ? null
          : Categorie.fromJson(json['category'] as Map<String, dynamic>),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MostPopularCategoryToJson(
  MostPopularCategory instance,
) => <String, dynamic>{'category': instance.category, 'count': instance.count};
