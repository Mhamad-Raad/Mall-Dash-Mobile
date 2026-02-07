# Quick Start Guide - Mall Dash Mobile

## 🚀 5-Minute Setup

### Prerequisites
- Flutter SDK 3.9.0+
- Dart SDK 3.9.0+
- Your favorite IDE (VS Code or Android Studio)

### Installation Steps

1. **Clone the repository**
```bash
git clone https://github.com/Mhamad-Raad/Mall-Dash-Mobile.git
cd Mall-Dash-Mobile
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

That's it! You should now see the app running with the login screen.

## 🎨 Using the Design System

### Accessing Theme Colors

```dart
import '../theme/app_colors.dart';

// In your widget
final isDark = Theme.of(context).brightness == Brightness.dark;

Container(
  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
)
```

### Using Typography

```dart
import '../theme/app_text_styles.dart';

Text(
  'Welcome Back!',
  style: AppTextStyles.h2,
)
```

### Using Spacing

```dart
import '../theme/app_spacing.dart';

Padding(
  padding: const EdgeInsets.all(AppSpacing.md), // 16px
  child: SizedBox(height: AppSpacing.buttonHeightMd), // 48px
)
```

### Toggle Theme

```dart
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

// In your widget
final themeProvider = Provider.of<ThemeProvider>(context);

IconButton(
  icon: Icon(
    themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
  ),
  onPressed: () {
    themeProvider.toggleTheme();
  },
)
```

## 🧩 Using Reusable Widgets

### Custom Button

```dart
import '../widgets/custom_button.dart';

CustomButton(
  text: 'Sign In',
  onPressed: () {
    // Handle button press
  },
  variant: ButtonVariant.primary, // or secondary, text, gradient
  size: ButtonSize.medium, // or small, large
  isLoading: false,
  icon: Icons.login, // optional
)
```

### Custom Text Field

```dart
import '../widgets/custom_text_field.dart';

CustomTextField(
  controller: _emailController,
  label: 'Email',
  hint: 'Enter your email',
  prefixIcon: Icons.email,
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  },
)
```

### Product Card

```dart
import '../widgets/product_card.dart';

ProductCard(
  name: 'Product Name',
  price: '\$19.99',
  imageUrl: 'https://example.com/image.jpg',
  rating: 4.5,
  onTap: () {
    // Handle product tap
  },
)
```

### Category Chip

```dart
import '../widgets/category_chip.dart';

CategoryChip(
  label: 'Electronics',
  isSelected: true,
  onTap: () {
    // Handle category selection
  },
)
```

### Custom Card

```dart
import '../widgets/custom_card.dart';

// Simple card
CustomCard(
  onTap: () {},
  child: Text('Card content'),
)

// Info card
InfoCard(
  icon: Icons.shopping_cart,
  title: 'Total Orders',
  value: '123',
  onTap: () {},
)
```

## 🛠️ Using Utilities

### Context Extensions

```dart
import '../utils/extensions.dart';

// In your widget
Widget build(BuildContext context) {
  // Easy theme access
  final isDark = context.isDarkMode;
  final theme = context.theme;
  final colorScheme = context.colorScheme;
  
  // Screen size checks
  if (context.isSmallScreen) {
    // Mobile layout
  } else if (context.isMediumScreen) {
    // Tablet layout
  } else {
    // Desktop layout
  }
  
  // Responsive sizing
  Container(
    width: 50.w(context), // 50% of screen width
    height: 25.h(context), // 25% of screen height
  );
}
```

### Snackbar Utilities

```dart
import '../utils/snackbar_utils.dart';

// Success message
SnackBarUtils.showSuccess(context, 'Login successful!');

// Error message
SnackBarUtils.showError(context, 'Invalid credentials');

// Warning message
SnackBarUtils.showWarning(context, 'Please verify your email');

// Info message
SnackBarUtils.showInfo(context, 'New feature available');
```

## 📱 Creating a New Screen

1. **Create the screen file**

```dart
// lib/screens/profile_page.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Text(
              'User Profile',
              style: AppTextStyles.h3.copyWith(
                color: isDark 
                  ? AppColors.darkTextPrimary 
                  : AppColors.lightTextPrimary,
              ),
            ),
            // Add more widgets
          ],
        ),
      ),
    );
  }
}
```

2. **Navigate to the screen**

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const ProfilePage()),
);
```

## 🎯 Common Patterns

### Building a Form

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      CustomTextField(
        label: 'Name',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
      ),
      const SizedBox(height: AppSpacing.md),
      CustomButton(
        text: 'Submit',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Process form
          }
        },
      ),
    ],
  ),
)
```

### Building a List

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return CustomCard(
      child: ListTile(
        title: Text(items[index].title),
        subtitle: Text(items[index].subtitle),
        onTap: () {
          // Handle tap
        },
      ),
    );
  },
)
```

### Building a Grid

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.75,
    crossAxisSpacing: AppSpacing.md,
    mainAxisSpacing: AppSpacing.md,
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(
      name: products[index].name,
      price: products[index].price,
      imageUrl: products[index].imageUrl,
      rating: products[index].rating,
      onTap: () {
        // Handle product tap
      },
    );
  },
)
```

## 🐛 Common Issues & Solutions

### Issue: Provider not found
**Solution:** Make sure you've wrapped your app with `ChangeNotifierProvider`:

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}
```

### Issue: Colors not updating on theme change
**Solution:** Always check brightness or use theme-aware colors:

```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
final color = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
```

### Issue: Widgets not rebuilding on theme change
**Solution:** Use `Consumer` or `context.watch()`:

```dart
Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    return Icon(
      themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
    );
  },
)
```

## 📚 Next Steps

1. **Read the full documentation**
   - [UI Implementation Guide](UI_IMPLEMENTATION_GUIDE.md)
   - [Design System Reference](DESIGN_SYSTEM.md)

2. **Explore the code**
   - Check out `lib/screens/` for screen examples
   - Look at `lib/widgets/` for reusable components
   - Review `lib/theme/` for the design system

3. **Start building**
   - Create new screens
   - Add business logic
   - Integrate APIs
   - Add more features

## 💡 Pro Tips

1. **Always use const constructors** when possible for better performance
2. **Use the theme system** - never hardcode colors or sizes
3. **Extract repeated code** into reusable widgets
4. **Follow the folder structure** for maintainability
5. **Check theme mode** before applying colors
6. **Use meaningful variable names** for better code readability

## 🤝 Need Help?

- Check the [UI Implementation Guide](UI_IMPLEMENTATION_GUIDE.md) for detailed instructions
- Review the [Design System](DESIGN_SYSTEM.md) for all design tokens
- Look at existing screens for examples
- Read inline code comments

Happy coding! 🚀
