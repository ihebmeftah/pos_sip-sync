import 'dart:io';

import 'package:admin/app/data/apis/htthp_helper.dart';
import 'package:admin/app/data/model/building/building.dart';

class BuildingsApi {
  Future<List<Building>> getBuildings() async {
    return await HttpHelper.get<List<Building>>(
      endpoint: '/building',
      fromJson: (data) {
        return (data as List).map((e) => Building.fromJson(e)).toList();
      },
    );
  }

  Future<Building> createBuilding(
    Building b, {
    required File? logo,
    required List<File> photos,
  }) async {
    print(b.openingTime.toUtc().toIso8601String());
    return await HttpHelper.post<Building>(
      endpoint: '/building',
      body: b.addtoJson(),
      files: [
        SingleFile(key: 'logo', file: logo),
        MultipleFile(key: 'photos', files: photos),
      ],
      fromJson: (data) {
        return Building.fromJson(data);
      },
    );
  }
}
