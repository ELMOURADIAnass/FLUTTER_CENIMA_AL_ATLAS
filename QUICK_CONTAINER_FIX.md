# Container Color/Decoration - One-Minute Fix Card

## THE PROBLEM
```
Assertion failed: color == null || decoration == null
Cannot provide both a color and a decoration.
```

---

## THE SOLUTION

### ❌ WRONG
```dart
Container(
  color: Colors.blue,
  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
)
```

### ✅ RIGHT
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.blue,  // MOVE COLOR HERE!
    borderRadius: BorderRadius.circular(8),
  ),
)
```

---

## WHEN TO USE WHAT

| Need | Use | Example |
|------|-----|---------|
| Only color | `color:` | `Container(color: Colors.blue)` |
| Color + styling | `decoration:` | `Container(decoration: BoxDecoration(color: ..., border: ...))` |
| Nothing | Neither | `Container(padding: EdgeInsets.all(16))` |

---

## 3-STEP FIX

1. **Copy** the color value
2. **Paste** it inside BoxDecoration  
3. **Delete** the original color line

---

## CODE TEMPLATES

### Template 1: Simple Card
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(blurRadius: 8)],
  ),
  padding: EdgeInsets.all(16),
  child: Widget(),
)
```

### Template 2: Simple Color Only
```dart
Container(
  color: Colors.blue,
  child: Widget(),
)
```

### Template 3: Button Style
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
  ),
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  child: Text('Click me'),
)
```

---

## GOLDEN RULE
**When in doubt, use `decoration` with `color` inside it.**

---

**That's it! You're fixed.** 🎉

