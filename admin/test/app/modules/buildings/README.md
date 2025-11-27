# Building Module Unit Tests

This directory contains comprehensive unit tests for the Buildings module in the Admin Flutter application.

## Test Structure

```
test/app/modules/buildings/
├── controllers/
│   ├── buildings_controller_test.dart      # Tests for BuildingsController
│   └── building_add_controller_test.dart   # Tests for BuildingAddController
```

## Test Helpers

### Fixtures

- `test/helpers/fixtures/building_fixtures.dart` - Contains mock data for buildings

### Mocks

- `test/helpers/mock_buildings_api.dart` - Mock implementation of BuildingsApi for testing
- `test/helpers/mock_http_helper.dart` - HTTP mock adapter for Dio requests (optional, using mock API instead)

## Dependencies

The tests use the following testing dependencies:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.5.1
  http_mock_adapter: ^0.6.1
```

## Key Features

### 1. **Mocked HTTP Calls**

All HTTP requests are mocked using a custom `MockBuildingsApi` class that implements the `BuildingsApi` interface. No real HTTP calls are made during testing.

### 2. **Dependency Injection**

Both `BuildingsController` and `BuildingAddController` have been updated to accept an optional `BuildingsApi` parameter, allowing for easy injection of mocks during testing:

```dart
final mockApi = MockBuildingsApi();
final controller = BuildingsController(api: mockApi);
```

### 3. **Comprehensive Test Coverage**

The tests cover:

- Controller initialization
- Successful API calls
- Error handling (ForbiddenException, UnauthorizedException, generic exceptions)
- State management
- Data integrity
- Form validation
- Multiple API call scenarios
- Error recovery

## Running the Tests

### Run all building module tests:

```bash
flutter test test/app/modules/buildings/
```

### Run specific controller tests:

```bash
flutter test test/app/modules/buildings/controllers/buildings_controller_test.dart
flutter test test/app/modules/buildings/controllers/building_add_controller_test.dart
```

### Run with coverage:

```bash
flutter test --coverage test/app/modules/buildings/
```

## Test Groups

### BuildingsController Tests

#### 1. Initialization Tests

- Verifies default values
- Checks initial state

#### 2. Success Scenarios

- `getBuilding()` fetches buildings successfully
- Handles empty lists correctly
- Updates observable state properly
- Maintains data integrity

#### 3. Error Handling

- ForbiddenException (403)
- UnauthorizedException (401)
- InternalServerErrorException (500)
- Generic exceptions

#### 4. State Management

- Transitions between success/error states
- Maintains last known good data on errors
- Multiple API call handling

### BuildingAddController Tests

#### 1. Initialization Tests

- Default values for text controllers
- Default opening/closing times
- Form key setup

#### 2. Text Controllers

- Name and location updates
- Controller clearing

#### 3. DTO Generation

- Correct building DTO creation
- Database name generation from restaurant name
- Special character handling in dbName

#### 4. Error Handling

- ConflictException handling
- Generic exception handling

#### 5. Form Validation

- Form key availability
- Form state access

#### 6. File Upload Integration

- FileuploadController access
- Logo and photos handling

## Mock Setup Examples

### Setting up successful response:

```dart
mockBuildingsApi.setupGetBuildings(BuildingFixtures.sampleBuildingList);
await controller.getBuilding();
```

### Setting up error response:

```dart
mockBuildingsApi.setupGetBuildingsError(ForrbidenException());
await controller.getBuilding();
```

### Resetting mock between tests:

```dart
mockBuildingsApi.reset();
```

## Best Practices

1. **Isolation**: Each test is isolated and doesn't affect others
2. **Cleanup**: `tearDown()` method resets GetX and mocks after each test
3. **Descriptive Names**: Test names clearly describe what is being tested
4. **AAA Pattern**: Tests follow Arrange-Act-Assert pattern
5. **Mock Reset**: Mocks are reset between tests to avoid side effects

## Test Results

Current test status: **42 tests passing** ✅

### Coverage Breakdown:

- BuildingsController: 26 tests
- BuildingAddController: 16 tests

## Future Enhancements

Consider adding tests for:

1. Widget tests for building views
2. Integration tests with real backend (using test database)
3. Performance tests for large datasets
4. Edge cases with special characters in building names
5. Concurrent API call handling

## Troubleshooting

### Common Issues:

1. **Get.context is null**:

   - Solution: Text controllers are initialized with fallback values when context is not available

2. **Async timing issues**:

   - Solution: Always `await` controller methods that make API calls

3. **Mock not working**:

   - Solution: Ensure the mock is properly set up before calling the controller method
   - Check that `mockApi.reset()` is called in `tearDown()`

4. **Tests failing after controller changes**:
   - Solution: Update the mock setup to match the new controller behavior

## Contributing

When adding new tests:

1. Follow the existing test structure
2. Use descriptive test names
3. Include both success and failure scenarios
4. Update this README if adding new test groups
5. Ensure all tests pass before committing

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Mockito Package](https://pub.dev/packages/mockito)
- [GetX Testing](https://github.com/jonataslaw/getx#testing)
