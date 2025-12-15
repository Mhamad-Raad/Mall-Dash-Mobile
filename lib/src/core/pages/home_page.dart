import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/language_selector.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.appTitle ?? 'Mall Dash'),
        actions: const [LanguageSelector(), ThemeToggleButton()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n?.appTitle ?? 'Mall Dash', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Text(
              '${l10n?.theme}: ${Theme.of(context).brightness == Brightness.light ? l10n?.lightTheme : l10n?.darkTheme}',
            ),
          ],
        ),
      ),
    );
  }
}
