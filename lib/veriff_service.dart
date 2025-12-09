// lib/backend_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BackendService {
  final Dio _dio;

  BackendService(String baseUrl) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<String> createVeriffSession(String userId) async {
    try {
      debugPrint('🔵 [BackendService] createVeriffSession for $userId');

      final response = await _dio.post(
        '/veriff/session',
        data: {'userId': userId},
      );

      debugPrint('✅ [BackendService] status: ${response.statusCode}');
      debugPrint('✅ [BackendService] data: ${response.data}');

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}: ${response.data}');
      }

      final data = response.data as Map<String, dynamic>;
      final sessionUrl = data['sessionUrl'] as String?;
      if (sessionUrl == null) {
        throw Exception('No sessionUrl in backend response');
      }

      return sessionUrl;
    } on DioException catch (e) {
      debugPrint('❌ [BackendService] DioException: ${e.message}');
      debugPrint('❌ [BackendService] response: ${e.response?.data}');
      throw Exception('Backend DioException: ${e.message}');
    } catch (e) {
      debugPrint('💥 [BackendService] Unknown error: $e');
      throw Exception("Unknown error in createSession: $e");
    }
  }
}
