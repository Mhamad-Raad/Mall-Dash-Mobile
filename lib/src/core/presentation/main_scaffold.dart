import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import '../design/design_system.dart';
import '../theme/custom_theme_extension.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_state.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/orders/presentation/orders_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/profile/presentation/user_profile_notifier.dart';
import '../../features/notifications/presentation/notifications_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/driver/presentation/driver_home_page.dart';
import '../constants/user_role.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _currentIndex = 1; // Default to Home (Middle)

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        // Check user role using UserRole constants
        final isDriver = UserRole.isDriver(profile.role);
        
        // Enhanced logging for debugging role-based navigation
        developer.log(
          'MainScaffold: User role detected',
          name: 'MainScaffold',
          error: 'Role: ${profile.role}, IsDriver: $isDriver, Email: ${profile.email}',
        );

        if (isDriver) {
          // Driver interface - single page navigation
          developer.log('Showing Driver interface', name: 'MainScaffold');
          return const DriverHomePage();
        } else {
          // Tenant interface - bottom navigation
          developer.log('Showing Tenant interface', name: 'MainScaffold');
          return _buildTenantScaffold();
        }
      },
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (error, _) => Scaffold(
        body: ErrorState(
          message: error.toString(),
          onRetry: () => ref.read(userProfileProvider.notifier).refresh(),
        ),
      ),
    );
  }

  Widget _buildTenantScaffold() {
    final List<Widget> pages = const [OrdersPage(), HomePage(), ProfilePage()];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mall Dash'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
