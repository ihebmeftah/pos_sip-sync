import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/themes/apptheme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

String url = GetPlatform.isAndroid
    ? "http://100.0.0.0:3000"
    : 'http://localhost:3000'
          "/";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().init();
  runApp(
    GetMaterialApp(
      title: "S&S Admin",
      theme: AppTheme().light,
      debugShowCheckedModeBanner: false,
      darkTheme: AppTheme().dark,
      themeMode: ThemeMode.light,
      initialRoute: Routes.AUTH,
      getPages: AppPages.routes,
    ),
  );
}
