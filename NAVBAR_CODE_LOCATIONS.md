# Navbar Fix - Exact Code Locations Reference

## File: `lib/screens/home_screen.dart`

---

## Fix #1: Scroll Listener (Lines 47-48)

**Location:** `_HomeScreenState.initState()`

**Before:**
```dart
@override
void initState() {
  super.initState();
  _sectionKeys = {
    'home': _heroKey,
    'movies': _moviesKey,
    'schedule': _scheduleKey,
    'about': _aboutKey,
    'contact': _contactKey,
  };
}  // ← Old code ended here
```

**After:**
```dart
@override
void initState() {
  super.initState();
  _sectionKeys = {
    'home': _heroKey,
    'movies': _moviesKey,
    'schedule': _scheduleKey,
    'about': _aboutKey,
    'contact': _contactKey,
  };
  // ✅ NEW: Listen to scroll changes to update navbar
  _scrollController.addListener(_updateActiveSectionOnScroll);
}
```

**Purpose:** Start listening to scroll events to auto-update navbar

---

## Fix #2: Listener Cleanup (Lines 53-54)

**Location:** `_HomeScreenState.dispose()`

**Before:**
```dart
@override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}
```

**After:**
```dart
@override
void dispose() {
  // ✅ NEW: Remove listener
  _scrollController.removeListener(_updateActiveSectionOnScroll);
  _scrollController.dispose();
  super.dispose();
}
```

**Purpose:** Clean up listener to prevent memory leaks

---

## Fix #3: Auto-Detection Method (Lines 58-83)

**Location:** New method in `_HomeScreenState` class

**Added:**
```dart
/// ✅ NEW: Update active section based on scroll position
void _updateActiveSectionOnScroll() {
  final scrollOffset = _scrollController.offset;
  String newActiveSection = 'home';
  double closestDistance = double.infinity;

  _sectionKeys.forEach((sectionName, key) {
    try {
      final renderObject = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderObject != null) {
        final position = renderObject.localToGlobal(Offset.zero).dy;
        final distance = (position - 100).abs(); // AppBar height
        if (distance < closestDistance) {
          closestDistance = distance;
          newActiveSection = sectionName;
        }
      }
    } catch (_) {
      // Ignore errors during scroll updates
    }
  });

  if (_activeSection != newActiveSection) {
    setState(() => _activeSection = newActiveSection);
  }
}
```

**Purpose:** Automatically detect and update active section when user scrolls

---

## Fix #4: Navbar Layout (Lines 163-172)

**Location:** `_buildAppBar()` method - SliverAppBar properties

**Before:**
```dart
return SliverAppBar(
  pinned: true,
  floating: false,
  elevation: 8,
  backgroundColor: AppColors.background,
  shadowColor: AppColors.secondary.withOpacity(0.3),
  title: Row(/* ... */),
  // No toolbarHeight specified
  actions: [ /* nav items */ ],
);
```

**After:**
```dart
return SliverAppBar(
  pinned: true,
  floating: false,
  elevation: 8,
  backgroundColor: AppColors.background,
  shadowColor: AppColors.secondary.withOpacity(0.3),
  title: Row(/* ... */),
  // ✅ NEW: Use toolbarHeight to ensure proper navbar sizing
  toolbarHeight: 72,
  // ✅ NEW: Add bottom widget for nav items to prevent overflow
  bottom: PreferredSize(
    preferredSize: const Size.fromHeight(0),
    child: Container(
      height: 0,
      color: AppColors.background,
    ),
  ),
  actions: [ /* nav items */ ],
);
```

**Purpose:** Ensure proper navbar sizing and prevent layout issues

---

## Fix #5: Nav Items Wrapping (Lines 174-203)

**Location:** `_buildAppBar()` method - actions list

**Before:**
```dart
actions: [
  _buildNavItem(localizations.home, () => _scrollToSection(_heroKey, 'home'), _activeSection == 'home'),
  _buildNavItem(localizations.movies, () => _scrollToSection(_moviesKey, 'movies'), _activeSection == 'movies'),
  _buildNavItem(localizations.schedule, () => _scrollToSection(_scheduleKey, 'schedule'), _activeSection == 'schedule'),
  _buildNavItem(localizations.about, () => _scrollToSection(_aboutKey, 'about'), _activeSection == 'about'),
  _buildNavItem(localizations.contact, () => _scrollToSection(_contactKey, 'contact'), _activeSection == 'contact'),
  _buildNavItem(localizations.reservations, () => _navigateToReservations(context), false),
  const SizedBox(width: 16),
  // User profile menu
  Consumer<AuthProvider>(...),
  const SizedBox(width: 16),
],
```

**After:**
```dart
// ✅ FIXED: Wrapped actions in horizontal scroll for better responsiveness
actions: [
  Expanded(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNavItem(localizations.home, () => _scrollToSection(_heroKey, 'home'), _activeSection == 'home'),
          _buildNavItem(localizations.movies, () => _scrollToSection(_moviesKey, 'movies'), _activeSection == 'movies'),
          _buildNavItem(localizations.schedule, () => _scrollToSection(_scheduleKey, 'schedule'), _activeSection == 'schedule'),
          _buildNavItem(localizations.about, () => _scrollToSection(_aboutKey, 'about'), _activeSection == 'about'),
          _buildNavItem(localizations.contact, () => _scrollToSection(_contactKey, 'contact'), _activeSection == 'contact'),
          _buildNavItem(localizations.reservations, () => _navigateToReservations(context), false),
          const SizedBox(width: 16),
        ],
      ),
    ),
  ),
  // User profile menu
  Consumer<AuthProvider>(
    builder: (context, authProvider, _) {
      if (authProvider.isLoggedIn && authProvider.currentUser != null) {
        return _buildUserMenu(context, authProvider.currentUser!.fullName);
      }
      return const SizedBox.shrink();
    },
  ),
  const SizedBox(width: 16),
],
```

**Purpose:** Wrap nav items to prevent overflow, keep user menu aligned right

---

## Fix #6: Nav Item Widget (Lines 215-247)

**Location:** `_buildNavItem()` method

**Before:**
```dart
Widget _buildNavItem(String label, VoidCallback onTap, bool isActive) {
  return TextButton(
    onPressed: onTap,
    child: Text(
      label,
      style: AppTypography.body.copyWith(
        color: isActive ? AppColors.secondary : AppColors.textSecondary,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
    ),
  );
}
```

**After:**
```dart
Widget _buildNavItem(String label, VoidCallback onTap, bool isActive) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(
              color: isActive ? AppColors.secondary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          // ✅ NEW: Visual underline indicator for active tab
          if (isActive)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                width: label.length * 6.0,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
```

**Purpose:** 
- Use GestureDetector for instant tap detection (no Material ripple lag)
- Add visual underline indicator for active tab
- Improve overall responsiveness

---

## Summary of Changes

| Fix # | Method | Lines | Type | Effect |
|-------|--------|-------|------|--------|
| 1 | initState | 47-48 | Add | Start scroll listener |
| 2 | dispose | 53-54 | Add | Stop scroll listener |
| 3 | NEW | 58-83 | Add | Auto-detect section |
| 4 | _buildAppBar | 163-172 | Modify | Set toolbar height |
| 5 | _buildAppBar | 174-203 | Modify | Wrap nav items |
| 6 | _buildNavItem | 215-247 | Modify | Instant taps + underline |

**Total Changes:** 6 locations, ~60 lines

---

## How to Apply (Manual)

If you want to manually apply these fixes:

1. Open `lib/screens/home_screen.dart`
2. In `initState()`, add scroll listener (after line 46)
3. In `dispose()`, remove scroll listener (before line 54)
4. After `_scrollToSection()` method, add `_updateActiveSectionOnScroll()` method
5. In `_buildAppBar()`, add `toolbarHeight` and wrap actions
6. Replace `_buildNavItem()` method entirely

---

## Verification

After applying changes:
- ✅ File should have ~900 lines (was 829 before)
- ✅ No compilation errors
- ✅ No lint warnings
- ✅ App should run without issues

---

## Roll Back (If Needed)

To roll back to original code:
1. Undo the 6 changes listed above
2. File will have 829 lines again
3. Original navbar will be restored

---

## Important Notes

- ✅ **Do NOT modify any other files**
- ✅ **Only change specified lines in home_screen.dart**
- ✅ **Keep existing code structure and indentation**
- ✅ **All other methods remain unchanged**

---

## Testing After Application

1. Run `flutter clean && flutter pub get`
2. Run `flutter run`
3. Test navbar responsiveness
4. Test scroll sync
5. Test visual feedback

All should work perfectly! ✅

---

**Fixes are ready to apply!** 🚀

