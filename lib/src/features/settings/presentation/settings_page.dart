import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/design/design_system.dart';
import '../../../core/providers/localization_provider.dart';
import '../../../core/providers/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.appTitle ?? 'Settings'),
      ),
      body: ListView(
        padding: AppSpacing.allMd,
        children: [
          // Language Section
          ListTile(
            title: Text(l10n?.language ?? 'Language'),
            leading: const Icon(Icons.language),
            trailing: DropdownButton<Locale>(
              value: locale,
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
                DropdownMenuItem(value: Locale('fa'), child: Text('Kurdî (Sorani)')),
              ],
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  ref.read(localeProvider.notifier).setLocale(newLocale);
                }
              },
            ),
          ),
          const Divider(),
          // Theme Section
          SwitchListTile(
            title: Text(l10n?.theme ?? 'Theme'),
            subtitle: Text(themeMode == ThemeMode.light ? (l10n?.lightTheme ?? 'Light') : (l10n?.darkTheme ?? 'Dark')),
            secondary: Icon(themeMode == ThemeMode.light ? Icons.wb_sunny : Icons.nightlight_round),
            value: themeMode == ThemeMode.dark,
            onChanged: (bool isDark) {
              ref.read(themeModeProvider.notifier).setTheme(isDark ? ThemeMode.dark : ThemeMode.light);
            },
          ),
        ],
      ),
    );
  }
}
