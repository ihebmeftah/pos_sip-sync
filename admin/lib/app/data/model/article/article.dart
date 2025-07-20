import 'package:admin/app/data/model/categorie/categorie.dart';
import 'package:json_annotation/json_annotation.dart';
part 'article.g.dart';

@JsonSerializable()
class Article {
  String id;
  String name;
  String? description;
  String? image;
  num price;
  @JsonKey(name: 'category')
  Categorie? categorie;

  Article({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.price,
    this.categorie,
  });
  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  Map<String, dynamic> addtoJson() => <String, dynamic>{
    'name': name,
    if (description != null) 'description': description,
    'price': price,
    'categoryId': categorie!.id,
  };
}
