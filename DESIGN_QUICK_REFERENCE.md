# 🎨 Quick Design Reference Guide

## COLOR PALETTE - Copy & Paste

```dart
// Cinema Theme Colors
const Color primaryBackground = Color(0xFF000000);  // Pure Black
const Color primaryAccent = Color(0xFFF4C518);      // Cinema Yellow ⭐
const Color cardBackground = Color(0xFF1A1A1A);    // Dark Gray
const Color surfaceLight = Color(0xFF2A2A2A);      // Lighter Gray
const Color primaryText = Color(0xFFFFFFFF);        // White
const Color secondaryText = Color(0xFFA1A1A1);     // Light Gray
const Color borders = Color(0xFF333333);            // Subtle Gray
```

## USING THE DESIGN SYSTEM

### In Your Code:
```dart
import 'package:flutter/material.dart';
import '../utils/theme.dart';

// Use colors:
Container(
  color: AppColors.background,  // Pure black
  child: Text(
    'Hello',
    style: AppTypography.h1,     // Bold heading
  ),
)

// Yellow accent:
Container(
  decoration: BoxDecoration(
    gradient: AppColors.accentGradient,  // Yellow gradient
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.4),  // Yellow glow
        blurRadius: 12,
      ),
    ],
  ),
)
```

## COMPONENT STYLING PATTERNS

### Yellow Accent Button:
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,  // Yellow
    foregroundColor: AppColors.background,  // Black text
    elevation: 8,
    shadowColor: AppColors.primary.withValues(alpha: 0.5),
  ),
  child: const Text('Action'),
)
```

### Yellow Gradient Badge:
```dart
Container(
  decoration: BoxDecoration(
    gradient: AppColors.accentGradient,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.4),
        blurRadius: 8,
      ),
    ],
  ),
)
```

### Premium Card with Hover:
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  decoration: BoxDecoration(
    color: AppColors.surface,  // Dark gray
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: _isHovered ? AppColors.primary : AppColors.border,
      width: _isHovered ? 1.5 : 1,
    ),
    boxShadow: [
      BoxShadow(
        color: _isHovered 
          ? AppColors.primary.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.4),
        blurRadius: _isHovered ? 16 : 8,
        offset: Offset(0, _isHovered ? 8 : 4),
      ),
    ],
  ),
)
```

### Typography Styles:
```dart
// Large heading
Text('Title', style: AppTypography.h1)

// Body text
Text('Content', style: AppTypography.body)

// Small caption
Text('Label', style: AppTypography.caption)

// Button text
Text('Click Me', style: AppTypography.button)

// With yellow accent:
Text('Important', style: AppTypography.accentHighlight)
```

## SPACING REFERENCE

```dart
// Common spacing values
const double spacingSmall = 8;
const double spacingMedium = 16;
const double spacingLarge = 24;
const double spacingXLarge = 32;
const double spacingSection = 48;
const double spacingLandscape = 80;

// Use in layouts:
SizedBox(height: 28)  // Between cards
SizedBox(height: 48)  // Between sections
SizedBox(height: 80)  // Between major sections
```

## SHADOWS REFERENCE

```dart
// Small shadow (badges, icons)
BoxShadow(
  color: Colors.black.withValues(alpha: 0.3),
  blurRadius: 8,
  offset: const Offset(0, 2),
)

// Medium shadow (cards)
BoxShadow(
  color: Colors.black.withValues(alpha: 0.4),
  blurRadius: 12,
  offset: const Offset(0, 6),
)

// Large shadow (elevated components)
BoxShadow(
  color: Colors.black.withValues(alpha: 0.5),
  blurRadius: 16,
  offset: const Offset(0, 8),
)

// Yellow glow (accent elements)
BoxShadow(
  color: AppColors.primary.withValues(alpha: 0.3),
  blurRadius: 12,
  offset: const Offset(0, 4),
)
```

## BORDER RADIUS REFERENCE

```dart
BorderRadius.circular(8)    // Small (inputs, small buttons)
BorderRadius.circular(12)   // Medium (form elements)
BorderRadius.circular(16)   // Large (cards, large buttons)
BorderRadius.circular(28)   // XLarge (tabs, badges)
```

## ELEVATION SYSTEM

```dart
elevation: 0      // Flat (inputs, backgrounds)
elevation: 4      // Slight (buttons default)
elevation: 8      // Medium (cards, elevated buttons)
elevation: 12     // High (app bar)
elevation: 16     // Very high (app bar with shadow)
```

## ANIMATION PATTERNS

```dart
// Standard animation
AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  curve: Curves.easeOutCubic,
  // ... properties change here
)

// Transform animations
transform: Matrix4.identity()..translate(0, _isHovered ? -8 : 0)

// Scale animations
AnimatedScale(
  scale: _isHovered ? 1.05 : 1.0,
  duration: const Duration(milliseconds: 250),
  child: Child(),
)
```

## TEXT STYLE COMBINATIONS

### Section Heading:
```dart
AppTypography.h2.copyWith(
  color: AppColors.textPrimary,
  letterSpacing: 1,
  fontWeight: FontWeight.w900,
)
```

### Card Title:
```dart
AppTypography.h4.copyWith(
  color: AppColors.textPrimary,
  fontSize: 16,
  fontWeight: FontWeight.w600,
)
```

### Secondary Text:
```dart
AppTypography.body.copyWith(
  color: AppColors.textSecondary,
  fontSize: 14,
)
```

### Yellow Accent Text:
```dart
AppTypography.caption.copyWith(
  color: AppColors.primary,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.3,
)
```

## COMMON PATTERNS

### Yellow Gradient Background:
```dart
decoration: BoxDecoration(
  gradient: AppColors.accentGradient,
  borderRadius: BorderRadius.circular(12),
)
```

### Dark Card Container:
```dart
decoration: BoxDecoration(
  color: AppColors.surface,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: AppColors.border),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ],
)
```

### Input Field Focus State:
```dart
focusedBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(
    color: AppColors.primary,
    width: 2,
  ),
)
```

### Hover Effect Container:
```dart
MouseRegion(
  onEnter: (_) => setState(() => _isHovered = true),
  onExit: (_) => setState(() => _isHovered = false),
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    transform: Matrix4.identity()..translate(0, _isHovered ? -8 : 0),
    decoration: BoxDecoration(
      color: AppColors.surface,
      boxShadow: [
        BoxShadow(
          color: _isHovered
            ? AppColors.primary.withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.4),
          blurRadius: _isHovered ? 16 : 8,
          offset: Offset(0, _isHovered ? 8 : 4),
        ),
      ],
    ),
  ),
)
```

## DO's & DON'Ts

### ✅ DO:
- Use yellow accent strategically (ratings, active states, CTAs)
- Apply consistent shadows and elevation
- Use 250ms animations with easeOutCubic
- Maintain 20px+ padding in inputs
- Use letter-spacing on headings
- Apply hover effects to interactive elements
- Use gradient on yellow accent elements

### ❌ DON'T:
- Avoid using red (old theme color)
- Don't use light backgrounds (we're dark mode)
- Avoid flat shadows (use elevation)
- Don't animate everything (be selective)
- Avoid poor contrast (white text on dark only)
- Don't mix border radius (stick to 12, 16, 28)
- Avoid small shadows (minimum 8px blur)

## TESTING CHECKLIST

- [ ] All text readable on dark backgrounds
- [ ] Yellow accents visible and not overused
- [ ] Hover effects work on interactive elements
- [ ] Shadows visible and appropriate depth
- [ ] Border radius consistent (12, 16, or 28)
- [ ] Animations smooth at 250ms duration
- [ ] Spacing generous (28px+ between cards)
- [ ] Buttons have elevation changes on hover
- [ ] Inputs have yellow focus border
- [ ] Mobile responsive and readable

## QUICK FIXES

**Text not readable?**
→ Use `AppColors.textPrimary` (white)

**Button not prominent?**
→ Add elevation: 8, shadow with primary color

**Card looks flat?**
→ Add `boxShadow` with 12px blur radius

**Hover not working?**
→ Wrap in `MouseRegion`, use `AnimatedContainer`

**Yellow not showing?**
→ Check if it's `AppColors.primary` (not a custom color)

**Spacing too tight?**
→ Increase to 28px between cards, 48px between sections

---

**Last Updated**: 2024 | **Theme Version**: 2.0 Cinema Dark

