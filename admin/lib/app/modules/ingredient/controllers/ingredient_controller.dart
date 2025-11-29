import 'package:admin/app/data/apis/ingredient_api.dart';
import 'package:admin/app/data/model/ingredient/ingredient.dart';
import 'package:get/get.dart';

class IngredientController extends GetxController with StateMixin {
  final ingredients = <Ingredient>[].obs;
  @override
  void onInit() async {
    await getIngredients();
    super.onInit();
  }

  Future<void> getIngredients() async {
    try {
      ingredients(await IngredientApi().fetchIngredients());
      if (ingredients.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(ingredients, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
