import 'package:get/get.dart';

import '../middleware/authenticated_middleware.dart';
import '../modules/article/bindings/article_binding.dart';
import '../modules/article/bindings/article_form_binding.dart';
import '../modules/article/views/article_form_view.dart';
import '../modules/article/views/article_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/bindings/register_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/buildings/bindings/building_add_binding.dart';
import '../modules/buildings/bindings/buildings_binding.dart';
import '../modules/buildings/views/building_add_view.dart';
import '../modules/buildings/views/buildings_view.dart';
import '../modules/categorie/bindings/categorie_binding.dart';
import '../modules/categorie/bindings/categorie_form_binding.dart';
import '../modules/categorie/views/categorie_form_view.dart';
import '../modules/categorie/views/categorie_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/index/bindings/index_binding.dart';
import '../modules/index/views/index_view.dart';
import '../modules/ingredient/bindings/ingredient_form_binding.dart';
import '../modules/ingredient/views/ingredient_form_view.dart';
import '../modules/ingredient/bindings/ingredient_binding.dart';
import '../modules/ingredient/views/ingredient_view.dart';
import '../modules/inventory/bindings/inventory_binding.dart';
import '../modules/inventory/views/inventory_view.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/bindings/order_details_binding.dart';
import '../modules/order/views/order_details_view.dart';
import '../modules/order/views/order_view.dart';
import '../modules/order/views/pass_order_view.dart';
import '../modules/qrscan/bindings/qrscan_binding.dart';
import '../modules/qrscan/views/qrscan_view.dart';
import '../modules/staff/bindings/staff_binding.dart';
import '../modules/staff/bindings/staff_details_binding.dart';
import '../modules/staff/bindings/staff_form_binding.dart';
import '../modules/staff/views/staff_details_view.dart';
import '../modules/staff/views/staff_form_view.dart';
import '../modules/staff/views/staff_view.dart';
import '../modules/tables/bindings/table_form_binding.dart';
import '../modules/tables/bindings/tables_binding.dart';
import '../modules/tables/views/table_form_view.dart';
import '../modules/tables/views/tables_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.INDEX,
      page: () => const IndexView(),
      bindings: [
        IndexBinding(),
        HomeBinding(),
        TablesBinding(),
        InventoryBinding(),
        OrderBinding(),
      ],
    ),
    GetPage(
      name: _Paths.TABLES,
      page: () => const TablesView(),
      binding: TablesBinding(),
      children: [
        GetPage(
          name: _Paths.TABLE_FORM,
          page: () => const TableFormView(),
          binding: TableFormBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
      middlewares: [AuthenticatedMiddleware()],
      children: [
        GetPage(
          name: _Paths.REGISTER,
          page: () => const RegisterView(),
          binding: RegisterBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.BUILDINGS,
      page: () => const BuildingsView(),
      binding: BuildingsBinding(),
      children: [
        GetPage(
          name: _Paths.BUILDING_ADD,
          page: () => const BuildingAddView(),
          binding: BuildingAddBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.INVENTORY,
      page: () => const InventoryView(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORIE,
      page: () => const CategorieView(),
      binding: CategorieBinding(),
      children: [
        GetPage(
          name: '${_Paths.CATEGORIE_FORM}/:id', // for update
          page: () => const CategorieFormView(),
          binding: CategorieFormBinding(),
        ),
        GetPage(
          name: _Paths.CATEGORIE_FORM,
          page: () => const CategorieFormView(),
          binding: CategorieFormBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.ARTICLE,
      page: () => const ArticleView(),
      binding: ArticleBinding(),
      children: [
        GetPage(
          name: '${_Paths.ARTICLE_FORM}/:id',
          page: () => const ArticleFormView(),
          binding: ArticleFormBinding(),
        ),
        GetPage(
          name: _Paths.ARTICLE_FORM,
          page: () => const ArticleFormView(),
          binding: ArticleFormBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => const OrderView(),
      binding: OrderBinding(),
      children: [
        GetPage(name: _Paths.PASS_ORDER, page: () => const PassOrderView()),
        GetPage(
          name: '${_Paths.ORDER_DETAILS}/:id',
          page: () => const OrderDetailsView(),
          binding: OrderDetailsBinding(),
        ),
        GetPage(
          name: '${_Paths.TABLES}/:tableId',
          page: () => const OrderView(),
          binding: OrderBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.STAFF,
      page: () => const StaffView(),
      binding: StaffBinding(),
      children: [
        GetPage(
          name: _Paths.STAFF_FORM,
          page: () => const StaffFormView(),
          binding: StaffFormBinding(),
        ),
        GetPage(
          name: '${_Paths.STAFF_DETAILS}/:id',
          page: () => const StaffDetailsView(),
          binding: StaffDetailsBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.QRSCAN,
      page: () => const QrscanView(),
      binding: QrscanBinding(),
    ),
    GetPage(
      name: _Paths.INGREDIENT,
      page: () => const IngredientView(),
      binding: IngredientBinding(),
      children: [
        GetPage(
          name: _Paths.INGREDIENT_FORM,
          page: () => const IngredientFormView(),
          binding: IngredientFormBinding(),
        ),
      ],
    ),
  ];
}
