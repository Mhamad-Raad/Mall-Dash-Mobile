# Mall Dash Mobile

A modern, beautifully designed Flutter e-commerce application with comprehensive dark and light theme support.

## 🌟 Features

- ✨ **Modern UI Design** - Clean and professional interface following Material Design 3 principles
- 🎨 **Dark & Light Themes** - Full support for both themes with smooth transitions
- 🎯 **Centralized Style Management** - All styles controlled from a single location
- 📱 **Responsive Layouts** - Works seamlessly across different screen sizes
- ⚡ **Performance Optimized** - Built with best practices for optimal performance
- 🧩 **Reusable Components** - Extensive library of customizable widgets
- 📚 **Well Documented** - Comprehensive implementation guide and code comments

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK (3.9.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Mhamad-Raad/Mall-Dash-Mobile.git
cd Mall-Dash-Mobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── theme/                    # Centralized theme system
│   ├── app_colors.dart      # Color palette
│   ├── app_text_styles.dart # Typography
│   ├── app_spacing.dart     # Spacing constants
│   ├── app_theme.dart       # Theme configuration
│   └── theme_provider.dart  # Theme state management
├── screens/                  # App screens
│   ├── login_page.dart      # Login screen
│   └── home_page.dart       # Home/Dashboard screen
├── widgets/                  # Reusable components
│   ├── product_card.dart    # Product display card
│   ├── category_chip.dart   # Category filter chip
│   ├── custom_button.dart   # Custom button widget
│   ├── custom_text_field.dart # Custom input field
│   └── custom_card.dart     # Custom card widget
├── utils/                    # Utility functions
│   ├── extensions.dart      # Helpful extensions
│   └── snackbar_utils.dart  # Snackbar helpers
└── models/                   # Data models
```

## 🎨 Design System

### Colors

The app uses a carefully crafted color palette supporting both light and dark themes:

- **Light Theme**: Purple (#6C63FF) primary with pink (#FF6584) accents
- **Dark Theme**: Lighter purple (#7F78FF) with adjusted colors for dark backgrounds

All colors are defined in `lib/theme/app_colors.dart`.

### Typography

Consistent text styles throughout the app:

- Headings: h1 (32px) → h6 (16px)
- Body: Large (16px), Medium (14px), Small (12px)
- Buttons: Large, Medium, Small variants

Defined in `lib/theme/app_text_styles.dart`.

### Spacing

Standardized spacing system:

- xs (4px), sm (8px), md (16px), lg (24px), xl (32px), xxl (48px), xxxl (64px)

Defined in `lib/theme/app_spacing.dart`.

## 🔧 Theme Switching

Toggle between light and dark themes:

```dart
// Access theme provider
final themeProvider = Provider.of<ThemeProvider>(context);

// Toggle theme
themeProvider.toggleTheme();

// Check current theme
if (themeProvider.isDarkMode) {
  // Dark mode logic
}
```

## 📖 Documentation

For detailed implementation guidelines, see [UI_IMPLEMENTATION_GUIDE.md](UI_IMPLEMENTATION_GUIDE.md).

The guide covers:
- Complete design system overview
- Step-by-step implementation instructions
- Component usage examples
- Best practices and performance tips
- Testing guidelines

## 🛠️ Built With

- [Flutter](https://flutter.dev/) - UI framework
- [Provider](https://pub.dev/packages/provider) - State management
- Material Design 3 - Design system

## 📱 Screens

### Login Page
- Modern authentication UI
- Email/password login
- Social login options (Google, Apple)
- Form validation
- Loading states

### Home Page
- Product grid display
- Category filtering
- Search functionality
- Theme switcher
- Bottom navigation

## 🎯 Upcoming Features

- Product details page
- Shopping cart
- User profile
- Order history
- Payment integration
- Push notifications

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**Mhamad Raad**

- GitHub: [@Mhamad-Raad](https://github.com/Mhamad-Raad)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for design guidelines
- The open-source community

---

Made with ❤️ using Flutter
