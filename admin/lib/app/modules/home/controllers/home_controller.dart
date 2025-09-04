import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/data/model/user/login_user.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  LoginUser loggedUser = LocalStorage().user!;
 
}
