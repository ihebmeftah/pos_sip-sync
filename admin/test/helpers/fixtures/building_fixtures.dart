import 'package:admin/app/data/model/building/building.dart';

class BuildingFixtures {
  static Building get sampleBuilding1 => Building(
    id: '123e4567-e89b-12d3-a456-426614174000',
    name: 'Test Restaurant 1',
    dbName: 'test_restaurant_1',
    openingTime: DateTime(2024, 1, 1, 7, 0),
    closingTime: DateTime(2024, 1, 1, 23, 0),
    location: 'Test Location 1',
    tableMultiOrder: false,
    long: 10.123456,
    lat: 36.654321,
    logo: '/uploads/building/logo1.png',
    photos: ['/uploads/building/photo1.png', '/uploads/building/photo2.png'],
  );

  static Building get sampleBuilding2 => Building(
    id: '223e4567-e89b-12d3-a456-426614174001',
    name: 'Test Restaurant 2',
    dbName: 'test_restaurant_2',
    openingTime: DateTime(2024, 1, 1, 8, 0),
    closingTime: DateTime(2024, 1, 1, 22, 0),
    location: 'Test Location 2',
    tableMultiOrder: true,
    long: 10.987654,
    lat: 36.123456,
    logo: '/uploads/building/logo2.png',
    photos: ['/uploads/building/photo3.png'],
  );

  static Building get sampleBuilding3 => Building(
    id: '323e4567-e89b-12d3-a456-426614174002',
    name: 'Test Restaurant 3',
    dbName: 'test_restaurant_3',
    openingTime: DateTime(2024, 1, 1, 6, 30),
    closingTime: DateTime(2024, 1, 1, 23, 30),
    location: 'Test Location 3',
    tableMultiOrder: false,
  );

  static List<Building> get sampleBuildingList => [
    sampleBuilding1,
    sampleBuilding2,
    sampleBuilding3,
  ];

  static Building get newBuilding => Building(
    name: 'New Restaurant',
    dbName: 'new_restaurant',
    openingTime: DateTime(2024, 1, 1, 9, 0),
    closingTime: DateTime(2024, 1, 1, 21, 0),
    location: 'New Location',
    tableMultiOrder: false,
  );

  static Building get createdBuilding => Building(
    id: '423e4567-e89b-12d3-a456-426614174003',
    name: 'New Restaurant',
    dbName: 'new_restaurant',
    openingTime: DateTime(2024, 1, 1, 9, 0),
    closingTime: DateTime(2024, 1, 1, 21, 0),
    location: 'New Location',
    tableMultiOrder: false,
    logo: '/uploads/building/new_logo.png',
    photos: ['/uploads/building/new_photo1.png'],
  );

  static List<Map<String, dynamic>> get sampleBuildingListJson => [
    sampleBuilding1.toJson(),
    sampleBuilding2.toJson(),
    sampleBuilding3.toJson(),
  ];

  static Map<String, dynamic> get createdBuildingJson =>
      createdBuilding.toJson();

  static List<Building> get emptyBuildingList => [];
}
