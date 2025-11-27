import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

class MockHttpHelper {
  late Dio dio;
  late DioAdapter dioAdapter;

  MockHttpHelper() {
    dio = Dio();
    dio.options.baseUrl = "http://192.168.0.124:3000/api/v1";
    dioAdapter = DioAdapter(dio: dio);
  }

  void mockGetBuildings(dynamic responseData, {int statusCode = 200}) {
    dioAdapter.onGet(
      '/building',
      (server) => server.reply(statusCode, responseData),
    );
  }

  void mockCreateBuilding(dynamic responseData, {int statusCode = 201}) {
    dioAdapter.onPost(
      '/building',
      (server) => server.reply(statusCode, responseData),
      data: Matchers.any,
    );
  }

  void mockGetBuildingById(
    String id,
    dynamic responseData, {
    int statusCode = 200,
  }) {
    dioAdapter.onGet(
      '/building/$id',
      (server) => server.reply(statusCode, responseData),
    );
  }

  void mockGetBuildingsError({int statusCode = 500, String? message}) {
    dioAdapter.onGet(
      '/building',
      (server) => server.reply(statusCode, {
        'message': message ?? 'Internal Server Error',
      }),
    );
  }

  void mockCreateBuildingError({int statusCode = 400, String? message}) {
    dioAdapter.onPost(
      '/building',
      (server) =>
          server.reply(statusCode, {'message': message ?? 'Bad Request'}),
      data: Matchers.any,
    );
  }

  void mockUnauthorizedError() {
    dioAdapter.onGet(
      '/building',
      (server) => server.reply(401, {'message': 'Unauthorized'}),
    );
  }

  void mockForbiddenError() {
    dioAdapter.onGet(
      '/building',
      (server) => server.reply(403, {'message': 'Forbidden'}),
    );
  }

  void mockConflictError() {
    dioAdapter.onPost(
      '/building',
      (server) => server.reply(409, {
        'message': 'Building with this name already exists',
      }),
      data: Matchers.any,
    );
  }

  void mockNetworkError() {
    dioAdapter.onGet(
      '/building',
      (server) => server.throws(
        0,
        DioException(
          requestOptions: RequestOptions(path: '/building'),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        ),
      ),
    );
  }

  void reset() {
    dioAdapter.reset();
  }

  void close() {
    dio.close();
  }
}
