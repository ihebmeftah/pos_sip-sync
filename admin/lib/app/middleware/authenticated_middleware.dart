import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticatedMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (LocalStorage().user == null) return null;
    if (LocalStorage().building != null) {
      return RouteSettings(name: Routes.INDEX);
    }
    return RouteSettings(name: Routes.BUILDINGS);
  }
}
