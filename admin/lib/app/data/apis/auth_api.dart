import 'dart:io';

import 'package:admin/app/data/apis/htthp_helper.dart';
import 'package:admin/app/data/model/user/login_user.dart';
import 'package:admin/app/data/model/user/user.dart';

class AuthApi {
  Future<LoginUser> login({
    required String identifier,
    required String password,
  }) async {
    return await HttpHelper.post<LoginUser>(
      endpoint: "/auth/login",
      fromJson: (data) {
        return LoginUser.fromJson(data);
      },
      body: {"identifier": identifier, "password": password},
    );
  }

  Future<LoginUser> register(User user, {File? image}) async {
    return await HttpHelper.post<LoginUser>(
      endpoint: "/auth/register",
      fromJson: (data) {
        return LoginUser.fromJson(data);
      },
      body: {...user.toJson(), "role": "Owner"},
      files: [SingleFile(key: 'photo', file: image)],
    );
  }
}
