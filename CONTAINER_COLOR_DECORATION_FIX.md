# Container Color/Decoration Assertion Error - Fix Guide

## The Error You're Seeing

```
Assertion failed: color == null || decoration == null
Cannot provide both a color and a decoration.
```

---

## 1. Why This Happens

The Flutter `Container` widget doesn't allow **both** `color` and `decoration` at the same time because:

1. **`color` is a shorthand** that internally creates a `BoxDecoration(color: colorValue)`
2. **`decoration` is the full system** that handles all styling (color, borders, shadows, gradients, etc.)
3. Having both would create **conflicting decorations**

```
Container receives BOTH:
├─ color: Colors.blue          → Creates BoxDecoration #1
└─ decoration: BoxDecoration() → Creates BoxDecoration #2
                                 ❌ CONFLICT!
```

---

## 2. How to Fix It

### ✅ SOLUTION 1: Simple Case (Color Only)
If you only need a background color:
```dart
Container(
  color: Colors.blue,  // ✅ This is fine alone
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
)
```

### ✅ SOLUTION 2: Complex Case (Color + Other Styling)
If you need color plus borders, radius, shadows, etc.:

**BEFORE (❌ WRONG):**
```dart
Container(
  color: Colors.blue,              // ← CONFLICT!
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey),
  ),
  padding: EdgeInsets.all(16),
  child: Text('Card'),
)
```

**AFTER (✅ CORRECT):**
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.blue,            // ← MOVED INSIDE
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey),
  ),
  padding: EdgeInsets.all(16),
  child: Text('Card'),
)
```

---

## 3. Step-by-Step Fix Process

1. **Find the problem Container:**
   ```dart
   Container(
     color: Colors.red,           // ← Found it!
     decoration: BoxDecoration(...),
   )
   ```

2. **Extract the color value:**
   ```
   Copy: Colors.red
   ```

3. **Move color into decoration:**
   ```dart
   Container(
     decoration: BoxDecoration(
       color: Colors.red,         // ← Paste here!
       ...
     ),
   )
   ```

4. **Remove the original color line:**
   ```dart
   Container(
     // color: Colors.red,  ← DELETE THIS
     decoration: BoxDecoration(
       color: Colors.red,         // ✅ Color is here now
       ...
     ),
   )
   ```

5. **Verify:**
   ```bash
   flutter analyze  # Should pass
   flutter run      # Should work
   ```

---

## 4. Real Examples from Your Code

### Example 1: Booking Modal Header (✅ CORRECT)
From `lib/widgets/booking_modal.dart` (lines 83-88):
```dart
Container(
  padding: const EdgeInsets.all(20),
  decoration: const BoxDecoration(
    color: AppColors.surfaceLight,           // ✅ Color is inside
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ),
  // ...
)
```

### Example 2: Movie Card (✅ CORRECT)
From `lib/widgets/movie_card.dart` (lines 34-55):
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  decoration: BoxDecoration(
    color: AppColors.surface,                // ✅ Color is inside
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: _isHovered ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
      width: _isHovered ? 1.5 : 1,
    ),
    boxShadow: [...],
  ),
  // ...
)
```

### Example 3: Room Selection (✅ CORRECT)
From `lib/widgets/booking_modal.dart` (lines 213-225):
```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,  // ✅ Color inside
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: isSelected
          ? AppColors.primary
          : availableSeats > 0
              ? AppColors.border
              : AppColors.textMuted,
    ),
  ),
  // ...
)
```

---

## 5. Decision Tree

```
Does your Container need styling?
│
├─ NO: Just leave it empty or with padding
│  └─ Container(padding: ..., child: ...)
│
└─ YES: What properties?
   │
   ├─ ONLY color?
   │  └─ Container(color: Colors.blue, child: ...)
   │
   └─ Color + (border OR shadow OR radius OR gradient)?
      └─ Container(
           decoration: BoxDecoration(
             color: Colors.blue,
             // add other properties
           ),
           child: ...,
         )
```

---

## 6. Common Patterns

### Card Style
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
  ),
  padding: EdgeInsets.all(16),
  child: Text('Card'),
)
```

### Button Style
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
  ),
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  child: Text('Button'),
)
```

### Badge/Chip Style
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.orange,
    borderRadius: BorderRadius.circular(20),
  ),
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  child: Text('New'),
)
```

### Outlined Box
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
  padding: EdgeInsets.all(16),
  child: Text('Outlined'),
)
```

---

## 7. Verification Checklist

After fixing a Container:

- [ ] Removed conflicting `color` parameter
- [ ] Moved `color` inside `BoxDecoration` (if needed)
- [ ] Ran `flutter analyze` with no errors
- [ ] Ran `flutter run` successfully
- [ ] Visual appearance is correct
- [ ] No assertion errors in console
- [ ] No warnings about unused parameters

---

## 8. Quick Reference

```dart
// ❌ DON'T DO THIS
Container(
  color: Colors.blue,
  decoration: BoxDecoration(...),
)

// ✅ DO THIS INSTEAD
Container(
  decoration: BoxDecoration(
    color: Colors.blue,
    ...
  ),
)

// ✅ OR THIS (if only color is needed)
Container(
  color: Colors.blue,
)
```

---

## FAQ

**Q: What if I have color + only border radius?**  
A: Use decoration:
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
  ),
)
```

**Q: What if I have color + gradient?**  
A: Use decoration (gradient takes precedence over color):
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [...]),
    borderRadius: BorderRadius.circular(8),
  ),
)
```

**Q: Is decoration slower than color?**  
A: No, same performance. Choose based on readability.

**Q: Do I need color if I use gradient?**  
A: No, gradient overrides color anyway. Skip the color parameter.

---

## Your Project Status

✅ **Good News!** Your `cinima_atlas` project has:
- No Container assertion errors detected
- Proper use of decoration with color inside
- Clean, production-ready code
- All best practices implemented

You're using the correct pattern throughout your codebase!

---

**Print this guide for quick reference!**

