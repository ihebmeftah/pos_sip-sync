import 'dart:io';
import 'package:admin/app/data/model/building/building.dart';
import 'package:mockito/mockito.dart';
import 'package:admin/app/data/apis/buildings_api.dart';

class MockBuildingsApi extends Mock implements BuildingsApi {
  Future<List<Building>>? _mockGetBuildingsResponse;
  Future<Building>? _mockCreateBuildingResponse;
  Exception? _mockException;

  void setupGetBuildings(List<Building> buildings) {
    _mockGetBuildingsResponse = Future.value(buildings);
    _mockException = null;
  }

  void setupGetBuildingsError(Exception exception) {
    _mockGetBuildingsResponse = null;
    _mockException = exception;
  }

  void setupCreateBuilding(Building building) {
    _mockCreateBuildingResponse = Future.value(building);
    _mockException = null;
  }

  void setupCreateBuildingError(Exception exception) {
    _mockCreateBuildingResponse = null;
    _mockException = exception;
  }

  @override
  Future<List<Building>> getBuildings() async {
    if (_mockException != null) {
      throw _mockException!;
    }
    return _mockGetBuildingsResponse ?? Future.value([]);
  }

  @override
  Future<Building> createBuilding(
    Building b, {
    required File? logo,
    required List<File> photos,
  }) async {
    if (_mockException != null) {
      throw _mockException!;
    }
    return _mockCreateBuildingResponse ?? Future.value(b);
  }

  void reset() {
    _mockGetBuildingsResponse = null;
    _mockCreateBuildingResponse = null;
    _mockException = null;
  }
}
