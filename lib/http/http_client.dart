import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpService {
  static HttpService? _instance;
  final Map<String, String> defaultHeaders;
  final Duration timeout = const Duration(seconds: 10);

  // Private constructor with headers initialization
  HttpService._internal({required this.defaultHeaders});

  // Factory constructor for singleton implementation
  factory HttpService({Map<String, String>? headers}) {
    return HttpService._internal(
      defaultHeaders:
          headers ?? {'Content-Type': 'application/json', 'X-user-agent': ''},
    );
  }

  // GET request method.
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: {...defaultHeaders, ...?headers})
          .timeout(timeout);
      return _processResponse(response);
    } catch (e) {
      throw Exception('GET request error: $e');
    }
  }

  // POST request method.
  Future<dynamic> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {...defaultHeaders, ...?headers},
            body: jsonEncode(body),
          )
          .timeout(timeout);
      return _processResponse(response);
    } catch (e) {
      throw Exception('POST request error: $e');
    }
  }

  // PUT request method.
  Future<dynamic> put(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: {...defaultHeaders, ...?headers},
            body: jsonEncode(body),
          )
          .timeout(timeout);
      return _processResponse(response);
    } catch (e) {
      throw Exception('PUT request error: $e');
    }
  }

  // DELETE request method.
  Future<dynamic> delete(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .delete(
            Uri.parse(url),
            headers: {...defaultHeaders, ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);
      return _processResponse(response);
    } catch (e) {
      throw Exception('DELETE request error: $e');
    }
  }

  // Processes the HTTP response.
  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body;
    if (statusCode >= 200 && statusCode < 300) {
      if (responseBody.isEmpty) {
        return responseBody;
      }
      return jsonDecode(responseBody);
    } else {
      throw Exception(
        'HTTP error: StatusCode: $statusCode, Body: $responseBody',
      );
    }
  }
}
