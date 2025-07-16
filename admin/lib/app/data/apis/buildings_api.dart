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

  Future<Building> createBuilding(Building b) async {
    return await HttpHelper.post<Building>(
      endpoint: '/building',
      body: b.addtoJson(),
      fromJson: (data) {
        return Building.fromJson(data);
      },
    );
  }
}
