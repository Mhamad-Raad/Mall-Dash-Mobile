import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/design/design_system.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../../core/widgets/language_selector.dart';
import '../../../core/widgets/loading_indicator.dart';
import 'auth_notifier.dart';
import 'login_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loginState = ref.watch(loginControllerProvider);

    ref.listen(loginControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString()), backgroundColor: Theme.of(context).colorScheme.error),
        );
      } else if (next is AsyncData && !next.isLoading) {
        // Notify AuthNotifier that we are authenticated
        ref.read(authNotifierProvider.notifier).setAuthenticated();
        // Navigation is handled by AuthWidget switching the widget tree,
        // but for good measure (and to avoid "Pop" issues if we were pushed),
        // we rely on AuthWidget which is the root.
        // However, if LoginPage was PUSHED (e.g. after logout), we might need to pop?
        // In our current setup, AuthWidget is the root. So when state changes, it rebuilds to MainScaffold.
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.loginTitle ?? 'Login'),
        actions: const [LanguageSelector(), ThemeToggleButton()],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.allLg,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.lock_person,
                    size: AppSpacing.iconAvatar,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  AppSpacing.verticalGapXl,
                  Text(
                    l10n?.welcomeMessage ?? 'Welcome back!',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.verticalGapXl,
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: l10n?.username ?? 'Username',
                      prefixIcon: const Icon(Icons.person),
                    ),
                    enabled: !loginState.isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.verticalGapMd,
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: l10n?.password ?? 'Password',
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    obscureText: true,
                    enabled: !loginState.isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.verticalGapLg,
                  FilledButton(
                    onPressed: loginState.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              ref
                                  .read(loginControllerProvider.notifier)
                                  .login(email: _usernameController.text, password: _passwordController.text);
                            }
                          },
                    child: loginState.isLoading
                        ? const LoadingIndicatorSmall()
                        : Text(l10n?.loginButton ?? 'Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
