import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/token_storage_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://maldash-development-api.runasp.net/MalDashApi',
      contentType: 'application/json',
    ),
  );

  final tokenStorage = ref.watch(tokenStorageServiceProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await tokenStorage.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          // If we get a 401, try to refresh the token
          final refreshToken = await tokenStorage.getRefreshToken();
          final accessToken = await tokenStorage.getAccessToken();

          if (refreshToken != null && accessToken != null) {
            try {
              // Create a new Dio instance to avoid circular dependencies/interceptors
              // for the refresh request itself.
              final refreshDio = Dio(
                BaseOptions(
                  baseUrl:
                      'https://maldash-development-api.runasp.net/MalDashApi',
                  contentType: 'application/json',
                ),
              );

              final response = await refreshDio.post(
                '/Account/refresh-token',
                data: {
                  'accessToken': accessToken,
                  'refreshToken': refreshToken,
                },
              );

              if (response.statusCode == 200) {
                final newAccessToken = response.data['accessToken'];
                final newRefreshToken = response.data['refreshToken'];

                await tokenStorage.saveTokens(
                  accessToken: newAccessToken,
                  refreshToken: newRefreshToken,
                );

                // Retry the original request with the new token
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
                
                final opts = Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                );
                
                final cloneReq = await dio.request(
                  error.requestOptions.path,
                  options: opts,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );

                return handler.resolve(cloneReq);
              }
            } catch (e) {
              // Refresh failed, clear tokens and let the error propagate
              await tokenStorage.clearTokens();
            }
          }
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
});
