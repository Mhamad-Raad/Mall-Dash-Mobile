import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_system.dart';
import '../../../core/theme/custom_theme_extension.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../profile/presentation/user_profile_notifier.dart';
import '../../profile/presentation/view_profile_page.dart';
import '../../auth/presentation/auth_notifier.dart';
import 'driver_shift_notifier.dart';

class DriverProfilePage extends ConsumerWidget {
  const DriverProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final shiftState = ref.watch(driverShiftNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Driver Profile')),
      body: ListView(
        padding: AppSpacing.allMd,
        children: [
          // Driver Profile Information Card
          profileAsync.when(
            data: (profile) => Card(
              elevation: 4,
              child: Padding(
                padding: AppSpacing.allMd,
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        final appTheme = context.appTheme;
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                          backgroundImage: profile.profileImageUrl != null
                              ? NetworkImage(profile.profileImageUrl!)
                              : null,
                          child: profile.profileImageUrl == null
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : null,
                        );
                      },
                    ),
                    AppSpacing.verticalGapMd,
                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.verticalGapXs,
                    Builder(
                      builder: (context) {
                        return Container(
                          padding: AppSpacing.statusBadge,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                            borderRadius: AppRadius.radiusPill,
                          ),
                          child: Text(
                            'DRIVER',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                    AppSpacing.verticalGapMd,
                    _InfoRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: profile.email,
                    ),
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: profile.phoneNumber,
                    ),
                  ],
                ),
              ),
            ),
            loading: () => const Card(
              elevation: 4,
              child: Padding(
                padding: AppSpacing.allMd,
                child: LoadingIndicator(),
              ),
            ),
            error: (error, _) => Card(
              elevation: 4,
              child: Padding(
                padding: AppSpacing.allMd,
                child: Text('Error: $error'),
              ),
            ),
          ),
          AppSpacing.verticalGapMd,

          // Current Shift Status Card
          shiftState.when(
            data: (shift) => Card(
              elevation: 4,
              child: ListTile(
                leading: Builder(
                  builder: (context) {
                    final appTheme = context.appTheme;
                    return Icon(
                      shift.isActive ? Icons.check_circle : Icons.cancel,
                      color: shift.isActive ? appTheme.successColor : appTheme.textTertiary,
                      size: AppSpacing.iconLg,
                    );
                  },
                ),
                title: const Text('Current Shift Status'),
                subtitle: Builder(
                  builder: (context) {
                    final appTheme = context.appTheme;
                    return Text(
                      shift.isActive ? 'Active Shift' : 'No Active Shift',
                      style: TextStyle(
                        color: shift.isActive ? appTheme.successColor : appTheme.textTertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                trailing: shift.isActive && shift.startTime != null
                    ? Text(
                        'Started: ${_formatTime(shift.startTime!)}',
                        style: const TextStyle(fontSize: 12),
                      )
                    : null,
              ),
            ),
            loading: () => const Card(
              elevation: 4,
              child: ListTile(
                leading: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                title: Text('Loading shift status...'),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
          AppSpacing.verticalGapMd,

          // Menu Items
          const Text(
            'Account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          AppSpacing.verticalGapXs,

          Card(
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Profile Information'),
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
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Delivery History'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Delivery history feature coming soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text('Performance Stats'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Performance stats feature coming soon'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          AppSpacing.verticalGapLg,

          // Settings
          const Text(
            'Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          AppSpacing.verticalGapXs,

          Card(
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Notification Settings'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Notification settings feature coming soon',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('App Settings'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('App settings feature coming soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Help & support feature coming soon'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          AppSpacing.verticalGapLg,

          // Logout Button
          Builder(
            builder: (context) {
              final appTheme = context.appTheme;
              return Card(
                elevation: 2,
                color: appTheme.errorColor.withOpacity(0.1),
                child: ListTile(
                  leading: Icon(Icons.logout, color: appTheme.errorColor),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: appTheme.errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => _handleDriverLogout(context, ref),
                ),
              );
            },
          ),
          AppSpacing.verticalGapMd,
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _handleDriverLogout(BuildContext context, WidgetRef ref) async {
    final shiftState = ref.read(driverShiftNotifierProvider);

    // Check if driver has an active shift
    final hasActiveShift = shiftState.value?.isActive ?? false;

    if (hasActiveShift) {
      // Warn driver about active shift
      final action = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Active Shift Detected'),
          content: const Text(
            'You have an active shift running. You should end your shift before logging out.\n\nDo you want to:',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, 'cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, 'end_and_logout'),
              child: const Text('End Shift & Logout'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, 'logout_anyway'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout Anyway'),
            ),
          ],
        ),
      );

      if (!context.mounted) return;

      if (action == 'end_and_logout') {
        // Show loading while ending shift
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Ending shift...'),
              ],
            ),
          ),
        );

        try {
          await ref.read(driverShiftNotifierProvider.notifier).endShift();
          if (context.mounted) {
            Navigator.pop(context); // Close loading dialog
            await _performLogout(context, ref);
          }
        } catch (e) {
          if (context.mounted) {
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to end shift: $e'),
                backgroundColor: context.appTheme.errorColor,
              ),
            );
          }
        }
      } else if (action == 'logout_anyway') {
        await _performLogout(context, ref);
      }
    } else {
      // No active shift, confirm logout
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      );

      if (confirmed == true && context.mounted) {
        await _performLogout(context, ref);
      }
    }
  }

  Future<void> _performLogout(BuildContext context, WidgetRef ref) async {
    try {
      // Show loading indicator
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      // Perform logout
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
      // Close loading dialog if still mounted
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: context.appTheme.errorColor,
          ),
        );
      }
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    return Padding(
      padding: AppSpacing.verticalXs,
      child: Row(
        children: [
          Icon(icon, size: 20, color: appTheme.textSecondary),
          AppSpacing.horizontalGapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: appTheme.textSecondary),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
