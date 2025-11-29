import 'package:admin/app/data/apis/htthp_helper.dart';
import 'package:admin/app/data/model/ingredient/ingredient.dart';

class IngredientApi {
  // Example method to fetch ingredients
  Future<List<Ingredient>> fetchIngredients() async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 2));
    return await HttpHelper.get<List<Ingredient>>(
      endpoint: "/ingredient",
      fromJson: (json) =>
          (json as List).map((item) => Ingredient.fromJson(item)).toList(),
    );
  }

  Future<Ingredient> createIngredient(Ingredient ingredient) async {
    return await HttpHelper.post(
      endpoint: "/ingredient",
      body: ingredient.toJson(),
      fromJson: (json) => Ingredient.fromJson(json),
    );
  }
}
