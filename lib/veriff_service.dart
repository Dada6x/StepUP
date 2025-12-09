import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // for debugPrint

class VeriffService {
  final Dio _dio = Dio();

  final String baseUrl;      // Example: https://stationapi.veriff.com
  final String apiKey;       // X-AUTH-CLIENT
  final String masterSecret; // currently unused for /sessions

  VeriffService({
    required this.baseUrl,
    required this.apiKey,
    required this.masterSecret,
  });

  Future<String> createSession(String userId) async {
    debugPrint('🔵 [VeriffService] createSession called with userId=$userId');

    final body = {
      "verification": {
        "vendorData": userId,
      }
    };

    final jsonBody = jsonEncode(body);
    debugPrint('📦 [VeriffService] Request body: $jsonBody');

    // ⛔ NO HMAC for POST /sessions (X-HMAC-SIGNATURE removed)
    final headers = {
      "Content-Type": "application/json",
      "X-AUTH-CLIENT": apiKey,
    };

    final url = "$baseUrl/v1/sessions";
    debugPrint('🌍 [VeriffService] POST $url');

    try {
      final response = await _dio.post(
        url,
        data: jsonBody,
        options: Options(headers: headers),
      );

      debugPrint('✅ [VeriffService] HTTP status: ${response.statusCode}');
      debugPrint('✅ [VeriffService] Raw response: ${response.data}');

      // Veriff returns 201 (Created) on success for /sessions
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("HTTP ${response.statusCode}: ${response.data}");
      }

      final data = response.data;
      if (data == null || data is! Map<String, dynamic>) {
        throw Exception("Unexpected response format (not a JSON map)");
      }

      final status = data["status"];
      debugPrint('ℹ️ [VeriffService] API status field: $status');

      final verification = data["verification"];
      if (verification == null || verification is! Map<String, dynamic>) {
        throw Exception("Missing 'verification' field in response");
      }

      final sessionUrl = verification["url"];
      if (sessionUrl == null || sessionUrl is! String) {
        throw Exception("Missing 'verification.url' in response");
      }

      debugPrint('🔗 [VeriffService] Session URL: $sessionUrl');

      return sessionUrl;
    } on DioException catch (e) {
      debugPrint('❌ [VeriffService] DioException caught!');
      debugPrint('❌ [VeriffService] type: ${e.type}');
      debugPrint('❌ [VeriffService] message: ${e.message}');
      debugPrint('❌ [VeriffService] response: ${e.response?.data}');
      throw Exception("DioException: ${e.message} | ${e.response?.data}");
    } catch (e, stack) {
      debugPrint('💥 [VeriffService] Unknown exception: $e');
      debugPrint('💥 [VeriffService] Stack trace: $stack');
      throw Exception("Unknown error in createSession: $e");
    }
  }
}
