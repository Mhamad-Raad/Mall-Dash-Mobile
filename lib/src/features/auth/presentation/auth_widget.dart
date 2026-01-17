import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_notifier.dart';
import 'login_page.dart';
import '../../../core/presentation/main_scaffold.dart';

class AuthWidget extends ConsumerStatefulWidget {
  const AuthWidget({super.key});

  @override
  ConsumerState<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends ConsumerState<AuthWidget> {
  @override
  void initState() {
    super.initState();
    // Check auth status when the widget initializes
    Future.microtask(() => ref.read(authNotifierProvider.notifier).checkAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(authNotifierProvider);

    // Use a key that changes with auth status to force complete rebuild
    // This ensures navigation stack is cleared when logging in/out
    final widgetKey = ValueKey('auth_${authStatus.name}');

    switch (authStatus) {
      case AuthStatus.initial:
        // You can return a splash screen here
        return Scaffold(
          key: widgetKey,
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      case AuthStatus.authenticated:
        return MainScaffold(key: widgetKey);
      case AuthStatus.unauthenticated:
        return LoginPage(key: widgetKey);
    }
  }
}
