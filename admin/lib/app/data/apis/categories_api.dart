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
  }) {
    return HttpHelper.multipart<Categorie>(
      endpoint: '/categroy',
      fields: {
        'name': name,
        if (description != null) 'description': description,
      },
      files: [],
      fromJson: (data) {
        return Categorie.fromJson(data);
      },
    );
  }
}
