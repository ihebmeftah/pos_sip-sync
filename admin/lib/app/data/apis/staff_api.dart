import 'dart:io';

import 'package:admin/app/data/apis/htthp_helper.dart';
import 'package:admin/app/data/model/employer/employer.dart';
import 'package:admin/app/data/model/user/user.dart';

class StaffApi {
  Future<List<Employer>> getEmployers() async {
    return HttpHelper.get<List<Employer>>(
      endpoint: '/users/employers',
      fromJson: (json) => (json as List)
          .map((e) => Employer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<Employer> getEmployerById(String id) async {
    return HttpHelper.get<Employer>(
      endpoint: '/users/employers/$id',
      fromJson: (json) => Employer.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Employer> addStaff(User user, File photo) async {
    return HttpHelper.post<Employer>(
      endpoint: '/users/employers/create',
      files: [SingleFile(key: 'photo', file: photo)],
      body: user.toJson(),
      fromJson: (json) => Employer.fromJson(json as Map<String, dynamic>),
    );
  }
}
