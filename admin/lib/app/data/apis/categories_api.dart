import 'dart:io';

import 'package:admin/app/data/apis/htthp_helper.dart';
import 'package:admin/app/data/model/categorie/categorie.dart';

class CategoriesApi {
  Future<List<Categorie>> getCategories() {
    return HttpHelper.get(
      endpoint: '/categroy',
      fromJson: (data) {
        return (data as List)
            .map((e) => Categorie.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<Categorie> createCategories({
    required String name,
    String? description,
    required File? image,
  }) {
    return HttpHelper.post<Categorie>(
      endpoint: '/categroy',
      body: {'name': name, if (description != null) 'description': description},
      files: [SingleFile(key: 'image', file: image)],
      fromJson: (data) {
        return Categorie.fromJson(data);
      },
    );
  }
}
