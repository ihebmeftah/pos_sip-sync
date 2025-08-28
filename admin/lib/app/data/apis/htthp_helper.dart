import 'dart:developer';
import 'dart:io';
import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';

abstract class HttpHelper {
  HttpHelper();

  static String get _baseUrl => getx.GetPlatform.isAndroid
      ? "http://100.0.0.0:3000/api/v1"
      : 'http://localhost:3000/api/v1';

  static Dio get _dio {
    final dio = Dio();
    dio.options.baseUrl = _baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);

    // Add interceptors
    dio.interceptors.add(_LoggingInterceptor());
    dio.interceptors.add(_AuthInterceptor());
    dio.interceptors.add(_BuildingInterceptor());

    return dio;
  }

  static Future<T> get<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  static Future<T> post<T>({
    required String endpoint,
    Map<String, String>? headers,
    Object? body,
    List<FileUpload>? files,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      FormData? formData;
      if (files != null) {
        formData = FormData();
        (body as Map<String, dynamic>).forEach((key, value) {
          formData!.fields.add(MapEntry(key, value.toString()));
        });
        for (final fileUpload in files) {
          if (fileUpload is SingleFile) {
            if (fileUpload.file != null) {
              final fileName = fileUpload.file!.path.split('/').last;
              formData.files.add(
                MapEntry(
                  fileUpload.key,
                  MultipartFile.fromFileSync(
                    fileUpload.file!.path,
                    filename: fileName,
                  ),
                ),
              );
            }
          } else if (fileUpload is MultipleFile) {
            if (fileUpload.files.isNotEmpty) {
              for (final file in fileUpload.files) {
                final fileName = file.path.split('/').last;
                formData.files.add(
                  MapEntry(
                    fileUpload.key,
                    MultipartFile.fromFileSync(file.path, filename: fileName),
                  ),
                );
              }
            }
          }
        }
      }
      final response = await _dio.post(
        endpoint,
        data: files != null ? formData : body,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  static Future<T> put<T>({
    required String endpoint,
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: body,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  static Future<T> patch<T>({
    required String endpoint,
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: body,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  static Future<T> delete<T>({
    required String endpoint,
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: body,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  static Exception _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    switch (statusCode) {
      case 400:
        return BadRequestException('Bad Request: $responseData');
      case 401:
        if (getx.Get.currentRoute == Routes.AUTH) return AuthException();
        LocalStorage().clear();
        getx.Get.offAllNamed(Routes.AUTH);
        return UnauthorizedException('Unauthorized: $responseData');
      case 403:
        return ForrbidenException('Forbidden: $responseData');
      case 404:
        if (getx.Get.currentRoute == Routes.AUTH) return AuthException();
        return NotFoundException('Not Found: $responseData');
      case 409:
        return ConflictException('Conflict: $responseData');
      case 500:
      case 502:
      case 503:
        return InternalServerErrorException(
          'Internal Server Error: $responseData',
        );
      default:
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          return Exception('Request timeout: ${error.message}');
        }
        if (error.type == DioExceptionType.connectionError) {
          return Exception('Connection error: ${error.message}');
        }
        return Exception('Request failed: ${error.message}');
    }
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("""
    ----- 🔘 HTTP RESPONSE � -----
    � ${response.statusCode} STATUS CODE : ${response.statusCode}
    METHOD : ${response.requestOptions.method}
    URL : ${response.requestOptions.uri}
    Response : ${response.data}
    """);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("""
    ----- 🔘 HTTP ERROR 🔘 -----
    🔴 ${err.response?.statusCode} STATUS CODE : ${err.response?.statusCode}
    METHOD : ${err.requestOptions.method}
    URL : ${err.requestOptions.uri}
    ERROR : ${err.message}
    DATA : ${err.response?.data}
    """);
    handler.next(err);
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add authorization header if user is logged in
    if (LocalStorage().user != null) {
      options.headers['Authorization'] = LocalStorage().token;
    }
    handler.next(options);
  }
}

class _BuildingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (LocalStorage().building != null) {
      options.headers['dbname'] = LocalStorage().dbName;
    }
    handler.next(options);
  }
}

abstract class FileUpload {
  final String key;

  FileUpload({required this.key});
}

class SingleFile extends FileUpload {
  final File? file;

  SingleFile({required super.key, this.file});
}

class MultipleFile extends FileUpload {
  final List<File> files;

  MultipleFile({required super.key, this.files = const []});
}
