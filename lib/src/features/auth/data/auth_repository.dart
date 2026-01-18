import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
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
      developer.log('Attempting login for: $email', name: 'AuthRepository');
      
      final response = await _dio.post(
        '/Account/login/mobile',
        data: {
          'email': email,
          'password': password,
          'applicationContext': applicationContext,
        },
      );

      developer.log(
        'Login response received',
        name: 'AuthRepository',
        error: 'Status: ${response.statusCode}, Data type: ${response.data.runtimeType}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        
        developer.log(
          'Login response data',
          name: 'AuthRepository',
          error: 'Keys: ${data.keys.join(", ")}',
        );

        // Handle different possible response formats
        final accessToken = data['accessToken'] ?? data['access_token'];
        final refreshToken = data['refreshToken'] ?? data['refresh_token'];

        if (accessToken != null && refreshToken != null) {
          developer.log('Saving authentication tokens', name: 'AuthRepository');
          await _tokenStorage.saveTokens(
            accessToken: accessToken.toString(),
            refreshToken: refreshToken.toString(),
          );
        } else {
          developer.log(
            'Warning: Login response missing tokens',
            name: 'AuthRepository',
            error: 'Response: $data',
          );
        }

        return data;
      } else {
        throw Exception('Login failed: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      developer.log('Login failed with DioException', name: 'AuthRepository', error: e.toString());
      
      String errorMessage = 'Login failed';
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        if (errorData is Map && errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        } else if (errorData is String) {
          errorMessage = errorData;
        }
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      developer.log('Login failed with exception', name: 'AuthRepository', error: e.toString());
      rethrow;
    }
  }

  Future<bool> validateToken() async {
    try {
      developer.log('Validating token with backend', name: 'AuthRepository');
      
      final response = await _dio.post(
        '/Account/validate-token',
        options: Options(
          validateStatus: (status) {
            if (status == null) return false;
            return true;
          },
        ),
      );
      
      final status = response.statusCode ?? 0;

      developer.log(
        'Token validation response',
        name: 'AuthRepository',
        error: 'Status: $status',
      );

      if (status == 200) {
        return true;
      }

      if (status == 401 || status == 403) {
        return false;
      }

      return true;
    } on DioException catch (e) {
      developer.log(
        'Token validation failed',
        name: 'AuthRepository',
        error: 'Status: ${e.response?.statusCode}, Message: ${e.message}',
      );
      final status = e.response?.statusCode;

      if (status == 401 || status == 403) {
        return false;
      }

      return true;
    } catch (e) {
      developer.log('Token validation error', name: 'AuthRepository', error: e.toString());
      return true;
    }
  }

  Future<void> logout() async {
    try {
      developer.log('Calling backend logout endpoint', name: 'AuthRepository');
      
      await _dio.post('/Account/logout/mobile');
      
      developer.log('Backend logout successful', name: 'AuthRepository');
    } on DioException catch (e) {
      developer.log(
        'Backend logout failed',
        name: 'AuthRepository',
        error: 'Status: ${e.response?.statusCode}, Message: ${e.message}',
      );
      // Continue to clear local tokens even if backend call fails
    } catch (e) {
      developer.log('Logout error', name: 'AuthRepository', error: e.toString());
    } finally {
      // Always clear local tokens
      developer.log('Clearing local tokens', name: 'AuthRepository');
      await _tokenStorage.clearTokens();
    }
  }
}
