import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_system.dart';
import '../../../core/theme/custom_theme_extension.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../auth/presentation/auth_notifier.dart';
import '../../support/presentation/support_tickets_page.dart';
import '../../settings/presentation/settings_page.dart';
import 'view_profile_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appTheme = context.appTheme;

    return ListView(
      padding: AppSpacing.allMd,
      children: [
        // Profile Header
        AppSpacing.verticalGapMd,
        Center(
          child: Icon(
            Icons.person,
            size: AppSpacing.iconAvatar,
            color: appTheme.textTertiary,
          ),
        ),
        AppSpacing.verticalGapMd,
        Center(
          child: Text(
            'My Account',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AppSpacing.verticalGapXl,

        // Menu Items
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person_outline, color: theme.colorScheme.primary),
                title: const Text('Profile Information'),
                subtitle: const Text('View and edit your details'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewProfilePage(),
                    ),
                  );
                },
              ),
              Divider(height: 1, color: appTheme.dividerColor),
              ListTile(
                leading: Icon(Icons.support_agent, color: appTheme.successColor),
                title: const Text('Support Tickets'),
                subtitle: const Text('Get help and track your requests'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SupportTicketsPage(),
                    ),
                  );
                },
              ),
              Divider(height: 1, color: appTheme.dividerColor),
              ListTile(
                leading: Icon(Icons.settings, color: appTheme.textSecondary),
                title: const Text('Settings'),
                subtitle: const Text('App preferences'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        AppSpacing.verticalGapLg,

        // Logout Button
        Card(
          color: appTheme.errorContainerColor,
          child: ListTile(
            leading: Icon(Icons.logout, color: appTheme.errorColor),
            title: Text(
              'Logout',
              style: TextStyle(
                color: appTheme.errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(foregroundColor: appTheme.errorColor),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true && context.mounted) {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const LoadingIndicator(),
                );

                try {
                  await ref.read(authNotifierProvider.notifier).logout();
                  
                  // Close loading dialog
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  
                  // Pop all routes to go back to root (AuthWidget will show LoginPage)
                  if (context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                } catch (e) {
                  // Close loading dialog
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Logout error: ${e.toString()}'),
                        backgroundColor: appTheme.errorColor,
                      ),
                    );
                  }
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
