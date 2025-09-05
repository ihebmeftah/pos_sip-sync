import 'dart:io';

import 'package:admin/app/data/apis/htthp_helper.dart';
import 'package:admin/app/data/model/user/login_user.dart';
import 'package:admin/app/data/model/user/user.dart';

class AuthApi {
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    return await HttpHelper.post<Map<String, dynamic>>(
      endpoint: "/auth/login",
      fromJson: (data) {
        return data as Map<String, dynamic>;
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
