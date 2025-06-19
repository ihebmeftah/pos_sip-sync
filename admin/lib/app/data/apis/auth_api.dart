import 'package:admin/app/data/apis/htthp_helper.dart';
import 'package:admin/app/data/model/user/login_user.dart';

class AuthApi {
  Future<LoginUser> login({
    required String email,
    required String password,
  }) async {
    return await HttpHelper.post<LoginUser>(
      endpoint: "/auth/login",
      fromJson: (data) {
        return LoginUser.fromJson(data);
      },
      body: {"email": email, "password": password},
    );
  }
}
