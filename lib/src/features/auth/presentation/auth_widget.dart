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

    switch (authStatus) {
      case AuthStatus.initial:
        // You can return a splash screen here
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      case AuthStatus.authenticated:
        return const MainScaffold();
      case AuthStatus.unauthenticated:
        return const LoginPage();
    }
  }
}
