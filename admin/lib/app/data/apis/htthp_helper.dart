import 'dart:convert';
import 'dart:developer';
import 'package:admin/app/data/apis/apis_exceptions.dart';
import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:get/get.dart' as getx;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class HttpHelper {
  HttpHelper();
  static Uri get _baseUrl => Uri.parse(
    getx.GetPlatform.isAndroid
        ? "http://100.0.0.0:3000"
        : 'http://localhost:3000'
              "/api/v1",
  );
  static Map<String, String> get _defaultHeaders => {
    if (LocalStorage().user != null) 'Authorization': LocalStorage().token,
    if (LocalStorage().building != null)
      'buildingid': LocalStorage().buildingId,
  };
  static Future<T> get<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  }) async {
    final uri = _buildUri(endpoint, queryParams);
    final response = await http.get(
      uri,
      headers: {..._defaultHeaders, if (headers != null) ...headers},
    );
    return _handleResponse<T>(
      endpoint: endpoint,
      response: response,
      fromJson: fromJson,
    );
  }

  static Future<T> post<T>({
    required String endpoint,
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  }) async {
    final uri = _buildUri(endpoint, queryParams);
    final response = await http.post(
      uri,
      headers: {
        ..._defaultHeaders,
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse<T>(
      response: response,
      endpoint: endpoint,
      fromJson: fromJson,
    );
  }

  // Multipart request method
  static Future<T> multipart<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
    required T Function(dynamic json) fromJson,
  }) async {
    final uri = _buildUri(endpoint, queryParams);
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      ..._defaultHeaders,
      if (headers != null) ...headers,
    });
    request.fields.addAll(fields);
    request.files.addAll(files);
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse<T>(
      response: response,
      endpoint: endpoint,
      fromJson: fromJson,
    );
  }

  static Future<T> put<T>({
    required String endpoint,
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  }) async {
    final uri = _buildUri(endpoint, queryParams);
    final response = await http.put(
      uri,
      headers: {
        ..._defaultHeaders,
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse<T>(
      response: response,
      endpoint: endpoint,
      fromJson: fromJson,
    );
  }

  static Future<T> patch<T>({
    required String endpoint,
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  }) async {
    final uri = _buildUri(endpoint, queryParams);
    final response = await http.patch(
      uri,
      headers: {
        ..._defaultHeaders,
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse<T>(
      response: response,
      endpoint: endpoint,
      fromJson: fromJson,
    );
  }

  static Future<T> delete<T>({
    required String endpoint,
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  }) async {
    final uri = _buildUri(endpoint, queryParams);
    final response = await http.delete(
      uri,
      headers: {
        ..._defaultHeaders,
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse<T>(
      response: response,
      endpoint: endpoint,
      fromJson: fromJson,
    );
  }

  // Helper to build Uri with query params
  static Uri _buildUri(String endpoint, Map<String, dynamic>? queryParams) {
    final base = '$_baseUrl$endpoint';
    if (queryParams == null || queryParams.isEmpty) {
      return Uri.parse(base);
    }
    final uri = Uri.parse(base);
    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        ...queryParams.map((k, v) => MapEntry(k, v.toString())),
      },
    );
  }

  static Future<T> _handleResponse<T>({
    required Response response,
    required String endpoint,
    required T Function(dynamic json) fromJson,
  }) async {
    log("""
    ----- 🔘 HTTP LOGGER 🔘 -----
    ${response.statusCode >= 200 && response.statusCode <= 299 ? "🟢" : "🔴"} ${response.statusCode} STATUS CODE : ${response.statusCode}
    Methode : ${response.request!.method}
    URL : ${response.request!.url}
    HEADERS : ${response.request!.headers}
    DATA : ${response.body}
    """);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 400) {
      throw BadRequestException('Bad Request: ${response.body}');
    } else if (response.statusCode == 401) {
      await LocalStorage().clear();
      getx.Get.offAllNamed(Routes.AUTH);
      throw UnauthorizedException('Unauthorized: ${response.body}');
    } else if (response.statusCode == 403) {
      throw ForrbidenException('Forbidden: ${response.body}');
    } else if (response.statusCode == 404) {
      throw NotFoundException('Not Found: ${response.body}');
    } else if (response.statusCode == 409) {
      throw ConflictException('Conflict: ${response.body}');
    } else if (response.statusCode >= 500) {
      throw InternalServerErrorException(
        'Internal Server Error: ${response.body}',
      );
    } else {
      throw Exception(
        'Request $endpoint failed with status: ${response.statusCode}',
      );
    }
  }
}
