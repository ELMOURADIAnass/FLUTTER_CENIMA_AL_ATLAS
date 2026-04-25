# Cinéma Al-ATLAS - Developer Guide

A comprehensive guide for developers working on the Cinéma Al-ATLAS project.

---

## Table of Contents

1. [Project Setup](#project-setup)
2. [Architecture Overview](#architecture-overview)
3. [Code Organization](#code-organization)
4. [Working with Providers](#working-with-providers)
5. [Database Operations](#database-operations)
6. [Common Tasks](#common-tasks)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

---

## Project Setup

### Initial Environment Setup

```bash
# 1. Install Flutter (if not already installed)
# Download from https://flutter.dev/docs/get-started/install

# 2. Verify Flutter installation
flutter --version
flutter doctor

# 3. Clone the project
git clone <repository-url>
cd cinima_atlas

# 4. Install dependencies
flutter pub get

# 5. Run the app
flutter run
```

### IDE Configuration

#### Android Studio / IntelliJ IDEA
1. Open project folder
2. Install Flutter and Dart plugins
3. Let IDE index the project
4. Run configuration will auto-detect

#### VS Code
1. Install Flutter and Dart extensions
2. Run `Flutter: New Project` command
3. Select existing project folder
4. Run with `F5` or `flutter run`

---

## Architecture Overview

### Layered Architecture

```
┌─────────────────────────────────────────┐
│        PRESENTATION LAYER               │
│  Screens, Widgets, UI Components        │
│  home_screen.dart, movie_card.dart     │
└─────────────────────────────────────────┘
              ↓ (UI reads from)
┌─────────────────────────────────────────┐
│    STATE MANAGEMENT LAYER (Providers)   │
│  auth_provider.dart                     │
│  movie_provider.dart                    │
│  booking_provider.dart                  │
│  reservation_provider.dart              │
│  language_provider.dart                 │
└─────────────────────────────────────────┘
              ↓ (calls methods)
┌─────────────────────────────────────────┐
│      SERVICE LAYER (Repositories)       │
│  auth_repository.dart                   │
│  database_service.dart                  │
└─────────────────────────────────────────┘
              ↓ (reads/writes)
┌─────────────────────────────────────────┐
│       DATA LAYER (Models & Database)    │
│  Models: movie.dart, user.dart, etc.   │
│  Storage: Hive database                 │
└─────────────────────────────────────────┘
```

### Data Flow Pattern

```
User Action (Tap Button)
         ↓
Widget calls Provider method
         ↓
Provider calls Service/Repository
         ↓
Service performs business logic
         ↓
Service calls Database/API
         ↓
Database returns data
         ↓
Service returns result to Provider
         ↓
Provider updates state via notifyListeners()
         ↓
Consumer widgets rebuild with new state
```

---

## Code Organization

### Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Classes | PascalCase | `MovieProvider`, `AuthRepository` |
| Methods | camelCase | `getMovieById()`, `setCategory()` |
| Variables | camelCase | `selectedCategory`, `errorMessage` |
| Constants | camelCase | `kAppBarHeight = 56` |
| Private members | _leadingUnderscore | `_movies`, `_currentUser` |
| Files | snake_case | `auth_provider.dart`, `home_screen.dart` |
| Directories | lowercase | `providers/`, `screens/`, `models/` |

### File Structure Guidelines

```dart
// 1. Imports (organized by source)
import 'package:flutter/material.dart';        // Framework
import 'package:provider/provider.dart';       // Third-party
import '../models/movie.dart';                 // Local
import '../services/auth_repository.dart';

// 2. Constants (if any)
const String kApiBaseUrl = 'https://api.example.com';

// 3. Main class definition
class MovieProvider extends ChangeNotifier {
  // 3a. Private variables
  List<Movie> _movies = [];
  MovieCategory _selectedCategory = MovieCategory.all;

  // 3b. Getters
  List<Movie> get movies => _movies;
  MovieCategory get selectedCategory => _selectedCategory;

  // 3c. Public methods
  void setCategory(MovieCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // 3d. Private helper methods
  void _loadMovies() {
    // Implementation
  }

  // 3e. Lifecycle methods (dispose)
  @override
  void dispose() {
    super.dispose();
  }
}
```

---

## Working with Providers

### Provider Pattern Fundamentals

Providers manage application state and notify listeners of changes.

#### Basic Provider Structure

```dart
import 'package:flutter/material.dart';

class MovieProvider extends ChangeNotifier {
  // State
  List<Movie> _movies = [];
  MovieCategory _selectedCategory = MovieCategory.all;

  // Getters
  List<Movie> get movies => _movies;
  List<Movie> get filteredMovies {
    if (_selectedCategory == MovieCategory.all) {
      return _movies;
    }
    return _movies
        .where((m) => m.category == _selectedCategory)
        .toList();
  }

  // Methods
  void setCategory(MovieCategory category) {
    _selectedCategory = category;
    notifyListeners(); // Notify listeners of changes
  }

  Future<void> loadMovies() async {
    try {
      // Load movies from database/API
      _movies = await _loadMoviesFromDatabase();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading movies: $e');
    }
  }
}
```

#### Using Providers in Widgets

```dart
// 1. Consumer Pattern (Most Common)
Consumer<MovieProvider>(
  builder: (context, movieProvider, child) {
    return ListView(
      children: movieProvider.filteredMovies
          .map((movie) => MovieCard(movie: movie))
          .toList(),
    );
  },
)

// 2. Selector Pattern (Specific State)
Selector<MovieProvider, List<Movie>>(
  selector: (context, provider) => provider.filteredMovies,
  builder: (context, filteredMovies, child) {
    return ListView(
      children: filteredMovies
          .map((movie) => MovieCard(movie: movie))
          .toList(),
    );
  },
)

// 3. Read Pattern (One-time Read)
ElevatedButton(
  onPressed: () {
    context.read<MovieProvider>().setCategory(MovieCategory.moroccan);
  },
  child: const Text('Filter Moroccan'),
)

// 4. Watch Pattern (In Build)
@override
Widget build(BuildContext context) {
  final movieProvider = context.watch<MovieProvider>();
  return Text('${movieProvider.movies.length} movies');
}
```

### Creating a New Provider

```dart
// lib/providers/example_provider.dart
import 'package:flutter/material.dart';

class ExampleProvider extends ChangeNotifier {
  // 1. Private state variables
  String _exampleState = 'initial';
  bool _isLoading = false;
  String? _errorMessage;

  // 2. Public getters
  String get exampleState => _exampleState;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 3. Public methods for state updates
  Future<void> performAction() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Perform operation
      _exampleState = 'updated';
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 4. Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
```

### Registering Provider in main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.initialize();
  runApp(const CinemaAtlasApp());
}

class CinemaAtlasApp extends StatelessWidget {
  const CinemaAtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Register all providers here
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MaterialApp(
        home: const HomeScreen(),
      ),
    );
  }
}
```

---

## Database Operations

### Hive Setup

#### Initialize Hive (main.dart)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await DatabaseService.initialize();
  
  runApp(const CinemaAtlasApp());
}
```

#### DatabaseService Structure

```dart
class DatabaseService {
  static const String roomsBoxName = 'rooms';
  static const String bookingsBoxName = 'bookings';

  static Box<dynamic>? _roomsBox;
  static Box<dynamic>? _bookingsBox;

  // Initialize Hive
  static Future<void> initialize() async {
    await Hive.initFlutter();
    _roomsBox = await Hive.openBox(roomsBoxName);
    _bookingsBox = await Hive.openBox(bookingsBoxName);

    if (_roomsBox!.isEmpty) {
      await seedDefaultRooms();
    }
  }

  // CRUD Operations
  static Future<void> saveData(String key, dynamic value) async {
    await _roomsBox?.put(key, value);
  }

  static dynamic getData(String key) {
    return _roomsBox?.get(key);
  }

  static Future<void> deleteData(String key) async {
    await _roomsBox?.delete(key);
  }

  static List<dynamic> getAllData() {
    return _roomsBox?.values.toList() ?? [];
  }
}
```

### Model Serialization

All models must implement `toMap()` and `fromMap()`:

```dart
// Movie model example
class Movie {
  final String id;
  final String title;
  // ... other fields

  // Convert to Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      // ... other fields
    };
  }

  // Create from Map retrieved from Hive
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as String,
      title: map['title'] as String,
      // ... other fields
    );
  }
}
```

### Common Hive Operations

```dart
// 1. Open a box
final myBox = await Hive.openBox('myBoxName');

// 2. Add/Update data
await myBox.put('key', value);

// 3. Get data by key
final value = myBox.get('key');

// 4. Get all values
final allValues = myBox.values.toList();

// 5. Delete data
await myBox.delete('key');

// 6. Clear entire box
await myBox.clear();

// 7. Check if key exists
final exists = myBox.containsKey('key');

// 8. Close box
await myBox.close();
```

---

## Common Tasks

### Adding a New Movie Screen

```dart
// 1. Create lib/screens/movie_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class MovieSelectionScreen extends StatelessWidget {
  const MovieSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Movie')),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, _) {
          return ListView(
            children: movieProvider.movies
                .map((movie) => ListTile(
                  title: Text(movie.title),
                  onTap: () {
                    // Handle selection
                  },
                ))
                .toList(),
          );
        },
      ),
    );
  }
}

// 2. Add route in main.dart
routes: {
  '/movie-selection': (context) => const MovieSelectionScreen(),
}

// 3. Navigate from another screen
Navigator.of(context).pushNamed('/movie-selection');
```

### Implementing Authentication

```dart
// 1. Call login method in AuthProvider
final success = await context.read<AuthProvider>().login(
  email: emailController.text,
  password: passwordController.text,
);

// 2. Handle response
if (success) {
  Navigator.of(context).pushReplacementNamed('/home');
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(context.read<AuthProvider>().errorMessage ?? 'Login failed'),
    ),
  );
}
```

### Making a Reservation

```dart
// 1. Prepare reservation data
final reservation = Reservation(
  id: const Uuid().v4(),
  filmName: selectedMovie.title,
  sessionTime: selectedTime,
  salle: selectedHall,
  seats: seatCount,
  totalPrice: selectedMovie.price * seatCount,
  createdAt: DateTime.now(),
  language: selectedMovie.language,
  moviePosterUrl: selectedMovie.posterUrl,
);

// 2. Add to provider
await context.read<ReservationProvider>().addReservation(reservation);

// 3. Show success feedback
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Reservation confirmed!')),
);
```

### Implementing Search

```dart
// In MovieProvider
List<Movie> searchMovies(String query) {
  final lowerQuery = query.toLowerCase();
  return _movies.where((movie) {
    return movie.title.toLowerCase().contains(lowerQuery) ||
        movie.director.toLowerCase().contains(lowerQuery) ||
        movie.genre.toLowerCase().contains(lowerQuery);
  }).toList();
}

// In UI
Consumer<MovieProvider>(
  builder: (context, movieProvider, _) {
    final results = movieProvider.searchMovies(searchQuery);
    return ListView(
      children: results
          .map((movie) => MovieCard(movie: movie))
          .toList(),
    );
  },
)
```

### Adding Localization

```dart
// 1. Edit lib/l10n/intl_fr.arb
{
  "greeting": "Bonjour",
  "bookNow": "Réserver maintenant"
}

// 2. Edit lib/l10n/intl_en.arb
{
  "greeting": "Hello",
  "bookNow": "Book Now"
}

// 3. Generate localization files
flutter gen-l10n

// 4. Use in code
Text(AppLocalizations.of(context)!.greeting)
```

---

## Best Practices

### State Management

✅ **DO:**
```dart
// Notify listeners after every state change
void updateState() {
  _state = newValue;
  notifyListeners();
}

// Use specific getters
String get errorMessage => _errorMessage;

// Validate inputs
Future<void> register(String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    _errorMessage = 'Email and password required';
    notifyListeners();
    return;
  }
  // proceed
}
```

❌ **DON'T:**
```dart
// Don't forget notifyListeners()
void updateState() {
  _state = newValue; // ❌ Listeners not notified
}

// Don't expose mutable state
List<Movie> get movies => _movies; // ❌ Can be modified externally

// Don't do heavy computations in getters
bool get isValid => expensiveCalculation(); // ❌ Bad performance
```

### Error Handling

✅ **DO:**
```dart
Future<void> login(String email, String password) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final success = await AuthRepository.login(
      email: email,
      password: password,
    );
    if (success) {
      _currentUser = AuthRepository.getCurrentUser();
    } else {
      _errorMessage = 'Invalid credentials';
    }
  } catch (e) {
    _errorMessage = 'Network error: ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

❌ **DON'T:**
```dart
// Don't ignore errors
Future<void> login(String email, String password) async {
  final success = await AuthRepository.login(email, password);
  // No error handling
}

// Don't show stack traces to users
catch (e) {
  _errorMessage = e.toString(); // ❌ User sees stack trace
}
```

### Widget Building

✅ **DO:**
```dart
// Use Consumer for specific state
Consumer<MovieProvider>(
  builder: (context, movieProvider, child) {
    return ListView(
      children: movieProvider.filteredMovies.map((m) => MovieCard(m)).toList(),
    );
  },
)

// Extract complex widgets
class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  const MovieGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    // Implementation
  }
}
```

❌ **DON'T:**
```dart
// Don't wrap entire tree in Consumer
Consumer<MovieProvider>(
  builder: (context, movieProvider, child) {
    return Scaffold( // ❌ Entire scaffold rebuilds
      body: ListView(
        children: movieProvider.movies.map((m) => MovieCard(m)).toList(),
      ),
    );
  },
)

// Don't build widgets inline
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Scaffold( // ❌ Complex structure
        body: Center(
          child: Text('Hello'),
        ),
      ),
    ],
  );
}
```

---

## Troubleshooting

### Common Issues & Solutions

#### Issue: "Box not found" Error
```
HiveError: Box not found. Did you forget to call Hive.openBox()?
```
**Solution:**
- Ensure `DatabaseService.initialize()` is called in `main()` before `runApp()`
- Check box name matches in `openBox()` and usage

#### Issue: Provider State Not Updating
```dart
// Provider method called but UI not rebuilding
```
**Solution:**
- Add `notifyListeners()` after state changes
- Ensure widget uses `Consumer` or `watch`
- Check Provider is registered in MultiProvider

#### Issue: Images Not Loading from Assets
```
Assets not found error
```
**Solution:**
- Verify asset paths in `pubspec.yaml`
```yaml
flutter:
  assets:
    - assets/images/
    - assets/images/posters/
```
- Use exact paths: `'assets/images/poster.jpg'`
- Run `flutter clean` and rebuild

#### Issue: Hive Box Already Open
```
HiveError: Box is already open
```
**Solution:**
- Don't open same box multiple times
- Use static box references
- Check `dispose()` methods close boxes properly

#### Issue: Localization Not Working
```
Localization strings not translating
```
**Solution:**
- Run `flutter gen-l10n` after editing `.arb` files
- Add localization delegates in `MaterialApp`
- Verify locale is set in provider

#### Issue: Password Verification Failing
```
Login fails but credentials appear correct
```
**Solution:**
- Ensure password is hashed consistently
- Check crypto package version matches
- Verify user was saved with hashed password

---

## Performance Tips

### Optimization Checklist

- [ ] Use `ListView.builder()` for large lists
- [ ] Implement lazy loading for images
- [ ] Use `Selector` for granular state updates
- [ ] Avoid rebuilding entire tree unnecessarily
- [ ] Cache frequently accessed data
- [ ] Profile with DevTools performance tab
- [ ] Use `const` constructors where possible
- [ ] Minimize widget tree depth

### Profiling

```bash
# Run with performance monitoring
flutter run --profile

# Open DevTools
flutter pub global activate devtools
devtools

# Check performance in browser
# Navigate to http://localhost:9100
```

---

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Hive Database](https://docs.hivedb.dev/)
- [Dart Language](https://dart.dev/guides)
- [Material Design](https://material.io/design)

---

**Last Updated**: April 2026  
**Version**: 1.0.0

