import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}

/// Thin HTTP GET wrapper shared by every remote source, with a short
/// timeout so a slow/unreachable network fails fast into a repository's
/// local fallback rather than hanging the UI.
class ApiClient {
  final http.Client _client;
  final Duration timeout;

  ApiClient({http.Client? client, this.timeout = const Duration(seconds: 8)})
    : _client = client ?? http.Client();

  Future<dynamic> getJson(String url) async {
    try {
      final response = await _client.get(Uri.parse(url)).timeout(timeout);
      if (response.statusCode != 200) {
        throw ApiException('HTTP ${response.statusCode} for $url');
      }
      return jsonDecode(response.body);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Request failed for $url: $e');
    }
  }
}
