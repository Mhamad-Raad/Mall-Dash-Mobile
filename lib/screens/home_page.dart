import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../theme/theme_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

/// Modern home page with dashboard and shopping features
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mall Dash'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode 
                ? Icons.light_mode 
                : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: 'Toggle theme',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: _buildBody(isDark),
      bottomNavigationBar: _buildBottomNavBar(isDark),
    );
  }

  Widget _buildBody(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    // Handle filter
                  },
                ),
              ),
            ),
          ),

          // Categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              'Categories',
              style: AppTextStyles.h5.copyWith(
                color: isDark 
                  ? AppColors.darkTextPrimary 
                  : AppColors.lightTextPrimary,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                CategoryChip(
                  label: 'All',
                  isSelected: true,
                  onTap: () {},
                ),
                const SizedBox(width: AppSpacing.sm),
                CategoryChip(
                  label: 'Electronics',
                  isSelected: false,
                  onTap: () {},
                ),
                const SizedBox(width: AppSpacing.sm),
                CategoryChip(
                  label: 'Fashion',
                  isSelected: false,
                  onTap: () {},
                ),
                const SizedBox(width: AppSpacing.sm),
                CategoryChip(
                  label: 'Home & Garden',
                  isSelected: false,
                  onTap: () {},
                ),
                const SizedBox(width: AppSpacing.sm),
                CategoryChip(
                  label: 'Sports',
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Featured products
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Products',
                  style: AppTextStyles.h5.copyWith(
                    color: isDark 
                      ? AppColors.darkTextPrimary 
                      : AppColors.lightTextPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Product grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return ProductCard(
                  name: 'Product ${index + 1}',
                  price: '\$${(index + 1) * 10}.99',
                  imageUrl: '',
                  rating: 4.5,
                  onTap: () {
                    // Handle product tap
                  },
                );
              },
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0, isDark),
              _buildNavItem(Icons.category, 'Categories', 1, isDark),
              _buildNavItem(Icons.favorite_border, 'Wishlist', 2, isDark),
              _buildNavItem(Icons.shopping_cart, 'Cart', 3, isDark),
              _buildNavItem(Icons.person, 'Profile', 4, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isDark) {
    final isSelected = _selectedIndex == index;
    final color = isSelected
        ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    return InkWell(
      onTap: () {
        setState(() => _selectedIndex = index);
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconMd),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
