import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'src/core/providers/shared_preferences_provider.dart';
import 'src/core/providers/theme_provider.dart';
import 'src/core/providers/localization_provider.dart';
import 'src/features/auth/presentation/auth_widget.dart';
import 'src/core/theme/custom_theme_extension.dart';
import 'src/core/design/design_system.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Mall Dash',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('fa')],
      home: const AuthWidget(),
    );
  }

  /// Build the light theme with comprehensive component styling.
  ThemeData _buildLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryContainer,
      error: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: AppShadows.elevationXs,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: AppTypography.sizeTitle,
          fontWeight: AppTypography.semiBold,
          color: colorScheme.onSurface,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        elevation: AppShadows.elevationSm,
        shape: AppRadius.cardShape,
        color: AppColors.cardBackground,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppShadows.elevationXs,
          padding: AppSpacing.buttonPadding,
          shape: AppRadius.buttonShape,
          foregroundColor: colorScheme.primary,
          backgroundColor: colorScheme.surface,
        ),
      ),
      
      // Filled button theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
          shape: AppRadius.buttonShape,
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: AppSpacing.buttonPadding,
          shape: AppRadius.buttonShape,
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: AppSpacing.buttonPadding,
          shape: AppRadius.buttonShape,
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: AppSpacing.formField,
      ),
      
      // List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: AppSpacing.horizontalMd,
        shape: AppRadius.cardShape,
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: AppShadows.elevationMd,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: AppColors.iconSecondary,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppShadows.elevationMd,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const CircleBorder(),
      ),
      
      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: AppRadius.cardShape,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
      
      // Dialog theme
      dialogTheme: DialogThemeData(
        elevation: AppShadows.elevationLg,
        shape: AppRadius.dialogShape,
        backgroundColor: colorScheme.surface,
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        elevation: AppShadows.elevationLg,
        shape: AppRadius.bottomSheetShape,
        backgroundColor: colorScheme.surface,
        modalElevation: AppShadows.elevationLg,
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        shape: AppRadius.chipShape,
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        padding: AppSpacing.horizontalXs,
      ),
      
      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.primaryContainer,
      ),
      
      // Extensions
      extensions: const [CustomThemeExtension.light],
    );
  }

  /// Build the dark theme with comprehensive component styling.
  ThemeData _buildDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.primaryDark,
      primaryContainer: AppColors.primaryContainerDark,
      secondary: AppColors.secondaryDark,
      secondaryContainer: AppColors.secondaryContainerDark,
      error: AppColors.errorLight,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      outline: AppColors.outlineDark,
      outlineVariant: AppColors.outlineVariantDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: AppShadows.elevationXs,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: AppTypography.sizeTitle,
          fontWeight: AppTypography.semiBold,
          color: colorScheme.onSurface,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        elevation: AppShadows.elevationSm,
        shape: AppRadius.cardShape,
        color: AppColors.cardBackgroundDark,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppShadows.elevationXs,
          padding: AppSpacing.buttonPadding,
          shape: AppRadius.buttonShape,
          foregroundColor: colorScheme.primary,
          backgroundColor: colorScheme.surface,
        ),
      ),
      
      // Filled button theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
          shape: AppRadius.buttonShape,
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: AppSpacing.buttonPadding,
          shape: AppRadius.buttonShape,
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: AppSpacing.buttonPadding,
          shape: AppRadius.buttonShape,
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: AppSpacing.formField,
      ),
      
      // List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: AppSpacing.horizontalMd,
        shape: AppRadius.cardShape,
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
        space: 1,
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: AppShadows.elevationMd,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: AppColors.iconSecondaryDark,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppShadows.elevationMd,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const CircleBorder(),
      ),
      
      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: AppRadius.cardShape,
        backgroundColor: AppColors.textPrimaryDark,
        contentTextStyle: const TextStyle(color: Colors.black),
      ),
      
      // Dialog theme
      dialogTheme: DialogThemeData(
        elevation: AppShadows.elevationLg,
        shape: AppRadius.dialogShape,
        backgroundColor: colorScheme.surface,
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        elevation: AppShadows.elevationLg,
        shape: AppRadius.bottomSheetShape,
        backgroundColor: colorScheme.surface,
        modalElevation: AppShadows.elevationLg,
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        shape: AppRadius.chipShape,
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        padding: AppSpacing.horizontalXs,
      ),
      
      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.primaryContainer,
      ),
      
      // Extensions
      extensions: const [CustomThemeExtension.dark],
    );
  }
}
