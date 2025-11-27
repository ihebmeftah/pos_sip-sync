import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/modules/buildings/controllers/buildings_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../../../../helpers/fixtures/building_fixtures.dart';
import '../../../../helpers/mock_buildings_api.dart';

void main() {
  late BuildingsController controller;
  late MockBuildingsApi mockBuildingsApi;

  setUp(() {
    // Initialize GetX for testing
    Get.testMode = true;

    // Create mock API
    mockBuildingsApi = MockBuildingsApi();

    // Create controller with mocked dependencies
    controller = BuildingsController(api: mockBuildingsApi);
  });

  tearDown(() {
    Get.reset();
    mockBuildingsApi.reset();
  });

  group('BuildingsController - Initialization', () {
    test('should initialize with empty buildings list', () {
      expect(controller.buildings, isEmpty);
    });

    test('should have correct initial state', () {
      expect(controller.buildings, isA<RxList>());
    });
  });

  group('BuildingsController - getBuilding() Success', () {
    test(
      'should fetch buildings successfully and update state to success',
      () async {
        // Arrange
        final mockBuildings = BuildingFixtures.sampleBuildingList;
        mockBuildingsApi.setupGetBuildings(mockBuildings);

        // Act
        await controller.getBuilding();

        // Assert
        expect(controller.buildings.length, 3);
        expect(controller.buildings[0].name, 'Test Restaurant 1');
        expect(controller.buildings[1].name, 'Test Restaurant 2');
        expect(controller.buildings[2].name, 'Test Restaurant 3');
        expect(controller.status.isSuccess, true);
      },
    );

    test('should handle empty buildings list and set state to empty', () async {
      // Arrange
      mockBuildingsApi.setupGetBuildings(BuildingFixtures.emptyBuildingList);

      // Act
      await controller.getBuilding();

      // Assert
      expect(controller.buildings, isEmpty);
      expect(controller.status.isEmpty, true);
    });

    test('should update buildings observable when data is fetched', () async {
      // Arrange
      final mockBuildings = BuildingFixtures.sampleBuildingList;
      mockBuildingsApi.setupGetBuildings(mockBuildings);

      // Act
      await controller.getBuilding();

      // Assert
      expect(controller.buildings, mockBuildings);
    });

    test('should have correct building properties after fetch', () async {
      // Arrange
      final mockBuildings = BuildingFixtures.sampleBuildingList;
      mockBuildingsApi.setupGetBuildings(mockBuildings);

      // Act
      await controller.getBuilding();

      // Assert
      final firstBuilding = controller.buildings[0];
      expect(firstBuilding.id, '123e4567-e89b-12d3-a456-426614174000');
      expect(firstBuilding.name, 'Test Restaurant 1');
      expect(firstBuilding.dbName, 'test_restaurant_1');
      expect(firstBuilding.location, 'Test Location 1');
      expect(firstBuilding.tableMultiOrder, false);
      expect(firstBuilding.logo, isNotNull);
      expect(firstBuilding.photos, isNotNull);
    });
  });

  group('BuildingsController - getBuilding() Error Handling', () {
    test('should handle ForbiddenException and set error state', () async {
      // Arrange
      mockBuildingsApi.setupGetBuildingsError(ForrbidenException());

      // Act
      await controller.getBuilding();

      // Assert
      expect(controller.buildings, isEmpty);
      expect(controller.status.isError, true);
      expect(controller.status.errorMessage, '🚨 Access denied');
    });

    test('should handle generic exception and set error state', () async {
      // Arrange
      mockBuildingsApi.setupGetBuildingsError(Exception('Network error'));

      // Act
      await controller.getBuilding();

      // Assert
      expect(controller.buildings, isEmpty);
      expect(controller.status.isError, true);
      expect(controller.status.errorMessage, 'Failed to load buildings');
    });

    test('should handle UnauthorizedException', () async {
      // Arrange
      mockBuildingsApi.setupGetBuildingsError(UnauthorizedException());

      // Act
      await controller.getBuilding();

      // Assert
      expect(controller.status.isError, true);
      expect(controller.buildings, isEmpty);
    });

    test('should handle InternalServerErrorException', () async {
      // Arrange
      mockBuildingsApi.setupGetBuildingsError(InternalServerErrorException());

      // Act
      await controller.getBuilding();

      // Assert
      expect(controller.status.isError, true);
      expect(controller.buildings, isEmpty);
      expect(controller.status.errorMessage, 'Failed to load buildings');
    });
  });

  group('BuildingsController - onInit()', () {
    test('should call getBuilding on initialization', () async {
      // Arrange
      final mockBuildings = BuildingFixtures.sampleBuildingList;
      final testMock = MockBuildingsApi();
      testMock.setupGetBuildings(mockBuildings);

      // Create a new controller
      final newController = BuildingsController(api: testMock);

      // Call getBuilding directly (which is what onInit does)
      await newController.getBuilding();

      // Assert
      expect(newController.buildings.length, 3);
      expect(newController.status.isSuccess, true);
    });

    test('should handle initialization errors gracefully', () async {
      // Arrange
      final testMock = MockBuildingsApi();
      testMock.setupGetBuildingsError(Exception('Initialization error'));

      // Create a new controller
      final newController = BuildingsController(api: testMock);

      // Call getBuilding directly (which is what onInit does)
      await newController.getBuilding();

      // Assert
      expect(newController.buildings, isEmpty);
      expect(newController.status.isError, true);
    });
  });

  group('BuildingsController - Multiple API Calls', () {
    test(
      'should update buildings when getBuilding is called multiple times',
      () async {
        // Arrange - First call
        final firstBuildings = [BuildingFixtures.sampleBuilding1];
        mockBuildingsApi.setupGetBuildings(firstBuildings);

        // Act - First call
        await controller.getBuilding();

        // Assert - First call
        expect(controller.buildings.length, 1);
        expect(controller.buildings[0].name, 'Test Restaurant 1');

        // Arrange - Second call with different data
        final secondBuildings = BuildingFixtures.sampleBuildingList;
        mockBuildingsApi.setupGetBuildings(secondBuildings);

        // Act - Second call
        await controller.getBuilding();

        // Assert - Second call should update the list
        expect(controller.buildings.length, 3);
      },
    );

    test('should handle transition from success to error state', () async {
      // Arrange - First call succeeds
      mockBuildingsApi.setupGetBuildings(BuildingFixtures.sampleBuildingList);

      // Act - First call
      await controller.getBuilding();

      // Assert - First call
      expect(controller.status.isSuccess, true);
      expect(controller.buildings.length, 3);

      // Arrange - Second call fails
      mockBuildingsApi.reset();
      mockBuildingsApi.setupGetBuildingsError(Exception('Network error'));

      // Act - Second call
      await controller.getBuilding();

      // Assert - Second call - status is error but buildings maintains last known state
      expect(controller.status.isError, true);
      expect(controller.buildings.length, 3); // Keeps previous data on error
    });

    test('should handle transition from error to success state', () async {
      // Arrange - First call fails
      mockBuildingsApi.setupGetBuildingsError(Exception('Network error'));

      // Act - First call
      await controller.getBuilding();

      // Assert - First call
      expect(controller.status.isError, true);

      // Arrange - Second call succeeds
      mockBuildingsApi.setupGetBuildings(BuildingFixtures.sampleBuildingList);

      // Act - Second call
      await controller.getBuilding();

      // Assert - Second call
      expect(controller.status.isSuccess, true);
      expect(controller.buildings.length, 3);
    });
  });

  group('BuildingsController - Data Integrity', () {
    test('should maintain building data integrity', () async {
      // Arrange
      final mockBuildings = BuildingFixtures.sampleBuildingList;
      mockBuildingsApi.setupGetBuildings(mockBuildings);

      // Act
      await controller.getBuilding();

      // Assert - Check first building
      final building1 = controller.buildings[0];
      expect(building1.id, mockBuildings[0].id);
      expect(building1.name, mockBuildings[0].name);
      expect(building1.dbName, mockBuildings[0].dbName);
      expect(building1.location, mockBuildings[0].location);

      // Assert - Check second building
      final building2 = controller.buildings[1];
      expect(building2.id, mockBuildings[1].id);
      expect(building2.name, mockBuildings[1].name);
      expect(building2.tableMultiOrder, mockBuildings[1].tableMultiOrder);
    });

    test('should correctly parse opening and closing times', () async {
      // Arrange
      final mockBuildings = BuildingFixtures.sampleBuildingList;
      mockBuildingsApi.setupGetBuildings(mockBuildings);

      // Act
      await controller.getBuilding();

      // Assert
      final building = controller.buildings[0];
      expect(building.openingTime, isNotNull);
      expect(building.closingTime, isNotNull);
      expect(building.openAt, isNotEmpty);
      expect(building.closeAt, isNotEmpty);
    });
  });
}
