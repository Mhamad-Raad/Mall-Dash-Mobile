import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_system.dart';
import '../../../core/theme/custom_theme_extension.dart';
import 'user_profile_notifier.dart';
import 'edit_profile_page.dart';

class ViewProfilePage extends ConsumerWidget {
  const ViewProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          profileState.when(
            data: (profile) => IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updated = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(profile: profile),
                  ),
                );
                
                if (updated == true) {
                  ref.read(userProfileProvider.notifier).refresh();
                }
              },
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: profileState.when(
        data: (profile) {
          return RefreshIndicator(
            onRefresh: () => ref.read(userProfileProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.allMd,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Profile Image
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    backgroundImage: profile.profileImageUrl != null
                        ? NetworkImage(profile.profileImageUrl!)
                        : null,
                    child: profile.profileImageUrl == null
                        ? Icon(Icons.person, size: 60, color: Theme.of(context).colorScheme.primary)
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Full Name
                  Text(
                    profile.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Role Badge
                  if (profile.role != null)
                    Container(
                      padding: AppSpacing.statusBadge,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                        borderRadius: AppRadius.radiusPill,
                      ),
                      child: Text(
                        profile.role!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),

                  // Information Cards
                  _buildInfoCard(
                    context: context,
                    icon: Icons.person_outline,
                    label: 'First Name',
                    value: profile.firstName.isNotEmpty ? profile.firstName : 'Not set',
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    context: context,
                    icon: Icons.person_outline,
                    label: 'Last Name',
                    value: profile.lastName.isNotEmpty ? profile.lastName : 'Not set',
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    context: context,
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: profile.email.isNotEmpty ? profile.email : 'Not set',
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    context: context,
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: profile.phoneNumber.isNotEmpty ? profile.phoneNumber : 'Not set',
                  ),
                  const SizedBox(height: 12),

                  if (profile.buildingName != null)
                    _buildInfoCard(
                      context: context,
                      icon: Icons.apartment_outlined,
                      label: 'Building',
                      value: profile.buildingName!,
                    ),
                  if (profile.buildingName != null) const SizedBox(height: 12),

                  if (profile.apartmentNumber != null)
                    _buildInfoCard(
                      context: context,
                      icon: Icons.home_outlined,
                      label: 'Apartment',
                      value: profile.apartmentNumber!,
                    ),
                  if (profile.apartmentNumber != null) const SizedBox(height: 12),

                  _buildInfoCard(
                    context: context,
                    icon: Icons.badge_outlined,
                    label: 'User ID',
                    value: profile.id.length > 8 
                        ? profile.id.substring(0, 8) + '...' 
                        : profile.id,
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          final appTheme = context.appTheme;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: appTheme.errorColor),
                const SizedBox(height: 16),
                Text(
                  'Error loading profile',
                  style: TextStyle(fontSize: 18, color: appTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    error.toString().replaceAll('Exception: ', ''),
                    style: TextStyle(color: appTheme.errorColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(userProfileProvider.notifier).refresh();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final appTheme = context.appTheme;
    return Card(
      child: Padding(
        padding: AppSpacing.allMd,
        child: Row(
          children: [
            Icon(icon, size: 24, color: appTheme.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: appTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
