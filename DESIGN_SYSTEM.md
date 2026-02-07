# Design System Reference

This document provides a visual reference for the Mall Dash Mobile design system.

## Color Palette

### Light Theme

#### Primary Colors
- **Primary**: `#6C63FF` - Main brand color
- **Primary Variant**: `#5A52E0` - Darker shade for hover/pressed states
- **Secondary**: `#FF6584` - Accent color
- **Secondary Variant**: `#FF4567` - Darker accent shade

#### Background Colors
- **Background**: `#F8F9FA` - Main background
- **Surface**: `#FFFFFF` - Card/surface background
- **Card**: `#FFFFFF` - Card background

#### Text Colors
- **Text Primary**: `#2D3436` - Main text color
- **Text Secondary**: `#636E72` - Secondary text color
- **Text Tertiary**: `#B2BEC3` - Tertiary/hint text color

#### Accent Colors
- **Accent**: `#FDCB6E` - Highlight color
- **Error**: `#FF3838` - Error states
- **Success**: `#00B894` - Success states
- **Warning**: `#FDCB6E` - Warning states
- **Info**: `#74B9FF` - Info states

#### Borders & Dividers
- **Border**: `#DFE6E9` - Border color
- **Divider**: `#ECF0F1` - Divider color

### Dark Theme

#### Primary Colors
- **Primary**: `#7F78FF` - Main brand color (lighter for dark bg)
- **Primary Variant**: `#9790FF` - Lighter shade for hover/pressed states
- **Secondary**: `#FF7A94` - Accent color (lighter for dark bg)
- **Secondary Variant**: `#FF92A8` - Lighter accent shade

#### Background Colors
- **Background**: `#1A1A2E` - Main background
- **Surface**: `#252541` - Card/surface background
- **Card**: `#2D2D44` - Card background

#### Text Colors
- **Text Primary**: `#ECF0F1` - Main text color
- **Text Secondary**: `#B2BEC3` - Secondary text color
- **Text Tertiary**: `#636E72` - Tertiary/hint text color

#### Accent Colors
- **Accent**: `#FDCB6E` - Highlight color
- **Error**: `#FF6B6B` - Error states
- **Success**: `#26DE81` - Success states
- **Warning**: `#FECE4A` - Warning states
- **Info**: `#4B7BEC` - Info states

#### Borders & Dividers
- **Border**: `#3D3D56` - Border color
- **Divider**: `#34344A` - Divider color

## Typography

### Heading Styles

| Style | Size | Weight | Line Height | Letter Spacing |
|-------|------|--------|-------------|----------------|
| H1    | 32px | Bold (700) | 1.2 | -0.5px |
| H2    | 28px | Bold (700) | 1.3 | -0.3px |
| H3    | 24px | SemiBold (600) | 1.3 | -0.2px |
| H4    | 20px | SemiBold (600) | 1.4 | -0.1px |
| H5    | 18px | SemiBold (600) | 1.4 | 0px |
| H6    | 16px | SemiBold (600) | 1.5 | 0px |

### Body Text Styles

| Style | Size | Weight | Line Height |
|-------|------|--------|-------------|
| Body Large | 16px | Regular (400) | 1.5 |
| Body Medium | 14px | Regular (400) | 1.5 |
| Body Small | 12px | Regular (400) | 1.5 |

### Label & Caption Styles

| Style | Size | Weight | Line Height | Letter Spacing |
|-------|------|--------|-------------|----------------|
| Label | 14px | Medium (500) | 1.4 | 0px |
| Caption | 12px | Regular (400) | 1.4 | 0px |
| Overline | 10px | Medium (500) | 1.6 | 1.5px |

### Button Text Styles

| Style | Size | Weight | Line Height | Letter Spacing |
|-------|------|--------|-------------|----------------|
| Button Large | 16px | SemiBold (600) | 1.2 | 0.5px |
| Button Medium | 14px | SemiBold (600) | 1.2 | 0.5px |
| Button Small | 12px | SemiBold (600) | 1.2 | 0.5px |

## Spacing System

### Base Spacing Values

| Name | Value | Usage |
|------|-------|-------|
| xs   | 4px   | Minimal spacing, tight layouts |
| sm   | 8px   | Small gaps between elements |
| md   | 16px  | Standard spacing (most common) |
| lg   | 24px  | Large gaps, section spacing |
| xl   | 32px  | Extra large gaps |
| xxl  | 48px  | Very large gaps |
| xxxl | 64px  | Maximum gaps |

### Border Radius

| Name | Value | Usage |
|------|-------|-------|
| radiusXs | 4px | Small elements |
| radiusSm | 8px | Buttons, chips |
| radiusMd | 12px | Cards, inputs (default) |
| radiusLg | 16px | Large cards |
| radiusXl | 24px | Hero cards |
| radiusFull | 9999px | Circular/pill shapes |

### Icon Sizes

| Name | Value | Usage |
|------|-------|-------|
| iconXs | 16px | Small icons |
| iconSm | 20px | List item icons |
| iconMd | 24px | Standard icons |
| iconLg | 32px | Large icons |
| iconXl | 48px | Hero icons |

### Component Heights

| Component | Height | Usage |
|-----------|--------|-------|
| Button Small | 36px | Compact buttons |
| Button Medium | 48px | Standard buttons |
| Button Large | 56px | Primary CTAs |
| Input Small | 40px | Compact inputs |
| Input Medium | 48px | Standard inputs |
| Input Large | 56px | Large inputs |
| App Bar | 56px | Top app bar |
| Bottom Nav | 60px | Bottom navigation |

## Components

### Buttons

#### Primary Button
- Background: Primary color gradient
- Text: White
- Height: 48px (default)
- Border Radius: 12px
- No border
- Elevation: 0

#### Secondary Button (Outlined)
- Background: Transparent
- Text: Primary color
- Border: 1px solid primary color
- Height: 48px (default)
- Border Radius: 12px

#### Text Button
- Background: Transparent
- Text: Primary color
- No border
- Height: auto
- Minimal padding

### Cards

#### Standard Card
- Background: Surface color
- Border Radius: 12px
- Elevation: 2
- Padding: 16px
- Margin: 8px

#### Product Card
- Aspect ratio: 0.75 (3:4)
- Image area: 60% of height
- Info area: 40% of height
- Favorite button: Top right
- Add to cart button: Bottom right

### Input Fields

#### Text Field
- Background: Surface color
- Border: 1px solid border color
- Focus Border: 2px solid primary color
- Border Radius: 12px
- Padding: 16px horizontal
- Height: 48px (default)
- Label: Floating
- Hint: Light gray

#### Search Field
- Same as text field
- Prefix Icon: Search icon
- Optional Suffix: Filter button
- No label

### Navigation

#### Bottom Navigation
- Height: 60px
- Background: Surface color
- Items: 5 max recommended
- Active color: Primary
- Inactive color: Text secondary
- Icon size: 24px
- Label size: 12px

#### App Bar
- Height: 56px
- Background: Surface color
- Elevation: 0
- Title: Center aligned
- Title size: 18px
- Icon size: 24px

## Gradients

### Primary Gradient (Light)
```
Linear Gradient
Start: #6C63FF (top-left)
End: #5A52E0 (bottom-right)
```

### Primary Gradient (Dark)
```
Linear Gradient
Start: #7F78FF (top-left)
End: #9790FF (bottom-right)
```

### Secondary Gradient (Light)
```
Linear Gradient
Start: #FF6584 (top-left)
End: #FF4567 (bottom-right)
```

### Secondary Gradient (Dark)
```
Linear Gradient
Start: #FF7A94 (top-left)
End: #FF92A8 (bottom-right)
```

## Shadows

### Card Shadow
```
Elevation: 2
Color: rgba(0, 0, 0, 0.05)
Blur: 10px
Offset: (0, 2)
```

### Bottom Navigation Shadow
```
Elevation: 4
Color: rgba(0, 0, 0, 0.05)
Blur: 10px
Offset: (0, -5)
```

## Grid System

### Product Grid
- Columns: 2
- Child Aspect Ratio: 0.75
- Cross Axis Spacing: 16px
- Main Axis Spacing: 16px
- Padding: 16px

## Breakpoints

### Screen Sizes
- Small (Mobile): < 600px
- Medium (Tablet): 600px - 900px
- Large (Desktop): > 900px

## Usage Examples

### Using Colors
```dart
import '../theme/app_colors.dart';

Container(
  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
)
```

### Using Text Styles
```dart
import '../theme/app_text_styles.dart';

Text(
  'Welcome',
  style: AppTextStyles.h2,
)
```

### Using Spacing
```dart
import '../theme/app_spacing.dart';

Padding(
  padding: EdgeInsets.all(AppSpacing.md),
  child: SizedBox(height: AppSpacing.buttonHeightMd),
)
```

### Checking Theme Mode
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
```

## Accessibility

### Contrast Ratios
- Normal text: Minimum 4.5:1
- Large text (18pt+): Minimum 3:1
- UI components: Minimum 3:1

### Touch Targets
- Minimum size: 44x44 pixels
- Recommended: 48x48 pixels

### Text Sizes
- Minimum body text: 14px
- Recommended body text: 16px
- Minimum tap target label: 12px

## Animation Guidelines

### Duration
- Micro interactions: 100-200ms
- UI transitions: 200-300ms
- Page transitions: 300-400ms

### Easing
- Standard: Cubic Bezier (0.4, 0.0, 0.2, 1)
- Deceleration: Cubic Bezier (0.0, 0.0, 0.2, 1)
- Acceleration: Cubic Bezier (0.4, 0.0, 1, 1)

---

This design system ensures consistency, maintainability, and a professional appearance across the entire application.
