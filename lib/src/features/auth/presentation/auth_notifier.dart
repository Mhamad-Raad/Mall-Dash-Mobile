import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/token_storage_service.dart';
import '../data/auth_repository.dart';

// Simple enum to represent auth state
enum AuthStatus { initial, authenticated, unauthenticated }

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthStatus>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    return AuthStatus.initial;
  }

  Future<void> checkAuthStatus() async {
    final tokenService = ref.read(tokenStorageServiceProvider);
    final refreshToken = await tokenService.getRefreshToken();

    if (refreshToken != null && refreshToken.isNotEmpty) {
      state = AuthStatus.authenticated;
    } else {
      state = AuthStatus.unauthenticated;
    }
  }

  Future<void> logout() async {
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
    } finally {
      // Ensure state is updated even if logout fails
      state = AuthStatus.unauthenticated;
    }
  }

  // Call this when login is successful
  void setAuthenticated() {
    state = AuthStatus.authenticated;
  }
}
