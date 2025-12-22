import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/storage/token_storage_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final tokenStorage = ref.watch(tokenStorageServiceProvider);
  return AuthRepository(dio: dio, tokenStorage: tokenStorage);
});

class AuthRepository {
  final Dio _dio;
  final TokenStorageService _tokenStorage;

  AuthRepository({required Dio dio, required TokenStorageService tokenStorage})
    : _dio = dio,
      _tokenStorage = tokenStorage;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String applicationContext,
  }) async {
    try {
      final response = await _dio.post(
        '/Account/login/mobile',
        data: {'email': email, 'password': password, 'applicationContext': applicationContext},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;

        // Save tokens if they exist in the response
        if (data.containsKey('accessToken') && data.containsKey('refreshToken')) {
          await _tokenStorage.saveTokens(accessToken: data['accessToken'], refreshToken: data['refreshToken']);
        }

        return data;
      } else {
        throw Exception('Login failed: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}
