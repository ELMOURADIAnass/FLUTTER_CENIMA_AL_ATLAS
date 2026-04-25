# Cinéma Al-ATLAS - Architecture & API Reference

Quick reference for the application architecture, components, and their interfaces.

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                  PRESENTATION LAYER                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ HomeScreen   │  │ LoginScreen  │  │ MovieDetail  │  │
│  │              │  │              │  │   Screen     │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  MovieCard   │  │BookingModal  │  │ FilterTabs   │  │
│  │              │  │              │  │              │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│          STATE MANAGEMENT LAYER (Providers)             │
│  ┌────────────────┐  ┌────────────────┐                │
│  │ AuthProvider   │  │ MovieProvider  │                │
│  │ - login()      │  │ - setCategory()│                │
│  │ - register()   │  │ - search()     │                │
│  │ - logout()     │  │ - getMovieById()               │
│  └────────────────┘  └────────────────┘                │
│  ┌────────────────┐  ┌────────────────┐                │
│  │BookingProvider │  │ReservationProv │                │
│  │- selectSeats() │  │- addReservation│                │
│  │- updatePrice() │  │- getHistory()  │                │
│  └────────────────┘  └────────────────┘                │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│              SERVICE LAYER (Repositories)               │
│  ┌──────────────────┐    ┌──────────────────┐          │
│  │ AuthRepository   │    │ DatabaseService  │          │
│  │ - register()     │    │ - initialize()   │          │
│  │ - login()        │    │ - saveData()     │          │
│  │ - updateProfile()│    │ - getData()      │          │
│  └──────────────────┘    └──────────────────┘          │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│           DATA LAYER (Models & Hive Database)           │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐      │
│  │  Movie   │  │   User   │  │  Reservation     │      │
│  │  Model   │  │  Model   │  │  Model           │      │
│  └──────────┘  └──────────┘  └──────────────────┘      │
│                                                         │
│           Hive Database (Local Storage)                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐      │
│  │  Users   │  │ Booking  │  │  Reservations    │      │
│  │   Box    │  │   Box    │  │     Box          │      │
│  └──────────┘  └──────────┘  └──────────────────┘      │
└─────────────────────────────────────────────────────────┘
```

---

## Provider API Reference

### AuthProvider

**Purpose**: Manages user authentication and profile state

**State Properties:**
```dart
User? currentUser                    // Current logged-in user
String? errorMessage                 // Last error message
bool isLoading                       // Loading state
bool isLoggedIn                      // Is user authenticated
```

**Methods:**
```dart
// Registration
Future<bool> register({
  required String email,
  required String password,
  required String fullName,
})

// Login
Future<bool> login({
  required String email,
  required String password,
})

// Profile updates
Future<bool> updateProfile({
  required String fullName,
})

// Password management
Future<bool> changePassword({
  required String currentPassword,
  required String newPassword,
})

// Session management
Future<void> logout()

// Error handling
void clearError()
```

**Usage Example:**
```dart
// In widget
Consumer<AuthProvider>(
  builder: (context, authProvider, _) {
    if (authProvider.isLoading) {
      return const CircularProgressIndicator();
    }
    return Text('Welcome, ${authProvider.currentUser?.fullName}');
  },
)

// Triggering action
ElevatedButton(
  onPressed: () async {
    final success = await context.read<AuthProvider>().login(
      email: 'user@example.com',
      password: 'password123',
    );
    if (success) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  },
  child: const Text('Login'),
)
```

---

### MovieProvider

**Purpose**: Manages movie catalog and filtering

**State Properties:**
```dart
List<Movie> movies                   // All movies
MovieCategory selectedCategory       // Currently filtered category
List<Movie> filteredMovies          // Filtered by category
List<Movie> featuredMovies          // First 4 movies
```

**Methods:**
```dart
// Filter management
void setCategory(MovieCategory category)

// Retrieval
Movie? getMovieById(String id)
List<Movie> searchMovies(String query)

// Getters (computed properties)
List<Movie> get filteredMovies
List<Movie> get featuredMovies
```

**MovieCategory Enum:**
```dart
enum MovieCategory {
  all,           // All movies
  moroccan,      // Moroccan films
  international, // International films
  classics,      // Classic films
  newReleases,   // Recently released
}
```

**Usage Example:**
```dart
// Get filtered movies
Consumer<MovieProvider>(
  builder: (context, movieProvider, _) {
    return GridView(
      children: movieProvider.filteredMovies
          .map((movie) => MovieCard(movie: movie))
          .toList(),
    );
  },
)

// Change filter
ElevatedButton(
  onPressed: () {
    context.read<MovieProvider>()
        .setCategory(MovieCategory.moroccan);
  },
  child: const Text('Moroccan Films'),
)

// Search movies
final results = movieProvider.searchMovies('Casablanca');
```

---

### BookingProvider

**Purpose**: Manages current booking session state

**State Properties:**
```dart
Movie? selectedMovie                 // Movie being booked
String? selectedShowtime              // Selected showtime
String? selectedHall                 // Selected cinema hall
int seatCount                        // Number of seats
double totalPrice                    // Total booking price
bool isProcessing                    // Processing state
```

**Methods:**
```dart
// Selection methods
void selectMovie(Movie movie)
void selectShowtime(String showtime)
void selectHall(String hall)
void setSeatCount(int count)

// Validation
bool isBookingComplete()
double calculatePrice()

// Processing
Future<bool> confirmBooking()
void resetBooking()
```

**Usage Example:**
```dart
// Update booking
Consumer<BookingProvider>(
  builder: (context, bookingProvider, _) {
    return Column(
      children: [
        Text('Seats: ${bookingProvider.seatCount}'),
        Text('Total: \$${bookingProvider.totalPrice}'),
        ElevatedButton(
          onPressed: bookingProvider.isBookingComplete()
              ? () => bookingProvider.confirmBooking()
              : null,
          child: const Text('Confirm Booking'),
        ),
      ],
    );
  },
)
```

---

### ReservationProvider

**Purpose**: Manages user reservation history with persistence

**State Properties:**
```dart
List<Reservation> reservations       // All user reservations
bool hasReservations                 // Are there any reservations?
int reservationCount                 // Number of reservations
```

**Methods:**
```dart
// Initialization
Future<void> initialize()

// CRUD operations
Future<void> addReservation(Reservation reservation)
Future<void> deleteReservation(String id)
Future<void> updateReservation(Reservation reservation)

// Retrieval
List<Reservation> searchByMovie(String title)
List<Reservation> getReservationsByDate(DateTime date)
Reservation? getReservationById(String id)
```

**Usage Example:**
```dart
// Display reservations
Consumer<ReservationProvider>(
  builder: (context, reservationProvider, _) {
    return ListView(
      children: reservationProvider.reservations
          .map((res) => ReservationCard(reservation: res))
          .toList(),
    );
  },
)

// Add reservation
final reservation = Reservation(
  id: const Uuid().v4(),
  filmName: 'Adam',
  sessionTime: '20:00',
  salle: 'Hall A',
  seats: 2,
  totalPrice: 120.0,
  createdAt: DateTime.now(),
  language: 'FR',
  moviePosterUrl: 'assets/images/adam.jpg',
);

await context.read<ReservationProvider>()
    .addReservation(reservation);
```

---

### LanguageProvider

**Purpose**: Manages app localization

**State Properties:**
```dart
Locale locale                        // Current locale
String language                      // Language code (en, fr, ar)
```

**Methods:**
```dart
// Language switching
void setLanguage(String languageCode)

// Getters
Locale get currentLocale
String get currentLanguage
```

**Supported Languages:**
- `en` - English
- `fr` - French (Default)
- `ar` - Arabic

**Usage Example:**
```dart
// Switch language
ElevatedButton(
  onPressed: () {
    context.read<LanguageProvider>().setLanguage('en');
  },
  child: const Text('English'),
)

// Use localized text
Text(AppLocalizations.of(context)!.bookNow)
```

---

## Service & Repository API

### AuthRepository

**Purpose**: Authentication business logic layer

**Static Methods:**
```dart
// Initialization
static Future<void> initialize()

// Registration
static Future<(bool, String)> register({
  required String email,
  required String password,
  required String fullName,
})
// Returns: (success, message)

// Login
static Future<(bool, String)> login({
  required String email,
  required String password,
})
// Returns: (success, message)

// Profile management
static Future<(bool, String)> updateProfile({
  required String fullName,
})

// Password management
static Future<(bool, String)> changePassword({
  required String currentPassword,
  required String newPassword,
})

// Session
static User? getCurrentUser()
static Future<void> logout()

// Utilities
static Future<bool> emailExists(String email)
static String hashPassword(String password)
```

---

### DatabaseService

**Purpose**: Hive database operations

**Static Methods:**
```dart
// Initialization
static Future<void> initialize()
static Future<void> close()

// Room operations
static List<Room> getAllRooms()
static Room? getRoomById(String id)
static Future<void> saveRoom(Room room)
static Future<void> deleteRoom(String id)
static Future<void> seedDefaultRooms()

// Seat availability
static int getAvailableSeats(
  String roomId,
  String movieId,
  DateTime date,
  String time,
)

// Booking operations
static Future<bool> bookSeats(
  String roomId,
  String movieId,
  DateTime date,
  String time,
  int seats,
)
```

---

## Model API Reference

### Movie Model

```dart
class Movie {
  final String id;
  final String title;
  final String originalTitle;
  final String director;
  final int year;
  final String duration;        // e.g., "1h 38min"
  final double rating;          // 0.0 - 5.0
  final String genre;           // e.g., "Drama/Thriller"
  final String synopsis;
  final String posterUrl;
  final double price;           // Per seat
  final MovieCategory category;
  final String language;        // e.g., "FR", "EN"
  final List<String> showtimes; // e.g., ["14:00", "17:00"]

  // Methods
  Movie copyWith({...})         // Immutable copy
}
```

### User Model

```dart
class User {
  final String id;              // UUID
  final String email;
  final String fullName;
  final String hashedPassword;  // Crypto hashed
  final DateTime createdAt;
  final DateTime? lastLogin;

  // Serialization
  Map<String, dynamic> toMap()
  factory User.fromMap(Map<String, dynamic> map)

  // Utilities
  User copyWith({...})
}
```

### Reservation Model

```dart
class Reservation {
  final String id;              // UUID
  final String filmName;
  final String sessionTime;     // e.g., "20:00"
  final String salle;           // Hall/Room name
  final int seats;
  final double totalPrice;
  final DateTime createdAt;
  final String language;
  final String moviePosterUrl;

  // Serialization
  Map<String, dynamic> toMap()
  factory Reservation.fromMap(Map<String, dynamic> map)

  // Utilities
  Reservation copyWith({...})
}
```

### Room Model

```dart
class Room {
  final String id;
  final String name;            // e.g., "Salle A"
  final int capacity;           // Total seats
  final String layoutType;      // "standard", "imax", etc.

  // Serialization
  Map<String, dynamic> toMap()
  factory Room.fromMap(Map<String, dynamic> map)
}
```

---

## Navigation API

### Routes

```dart
routes: {
  '/home': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/signup': (context) => const SignupScreen(),
  '/movie-detail': (context) => const MovieDetailScreen(),
  '/reservations': (context) => const ReservationHistoryScreen(),
}
```

### Navigation Methods

```dart
// Push new route
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const TargetScreen()),
)

// Push named route
Navigator.of(context).pushNamed('/movie-detail',
  arguments: movieId,
)

// Replace route (remove previous)
Navigator.of(context).pushReplacementNamed('/home')

// Pop to previous
Navigator.of(context).pop()

// Go to home and clear stack
Navigator.of(context).pushNamedAndRemoveUntil(
  '/home',
  (route) => false,
)
```

---

## Theme API

### Colors

```dart
AppColors.background      // #000000
AppColors.surface         // #1A1A1A
AppColors.surfaceLight    // #2A2A2A
AppColors.primary         // #F4C518 (Cinema Gold)
AppColors.primaryDark     // #D4A517
AppColors.textPrimary     // #FFFFFF
AppColors.textSecondary   // #A1A1A1
AppColors.textMuted       // #767676
AppColors.border          // #333333
AppColors.divider         // #333333
```

### Theme Access

```dart
// Get app theme
theme: AppTheme.darkTheme

// Access colors in widgets
Container(
  color: AppColors.surface,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)
```

---

## Error Handling

### Error Messages

```dart
// Provider error handling
Consumer<AuthProvider>(
  builder: (context, authProvider, _) {
    if (authProvider.errorMessage != null) {
      return Text(
        'Error: ${authProvider.errorMessage}',
        style: const TextStyle(color: Colors.red),
      );
    }
    return const SizedBox.shrink();
  },
)

// Repository error tuples
final (success, message) = await AuthRepository.login(
  email: email,
  password: password,
);
if (!success) {
  print('Login failed: $message');
}
```

### Common Error Messages

```
"Invalid credentials"           // Wrong email/password
"Email already registered"      // Duplicate email
"Network error: ..."            // Connection issue
"Current password incorrect"    // Password change failed
"Box not found"                 // Hive not initialized
"No available seats"            // Booking full
```

---

## Integration Examples

### Complete Login Flow

```dart
// 1. User enters email/password
// 2. Tap login button
final success = await context.read<AuthProvider>().login(
  email: emailController.text,
  password: passwordController.text,
);

// 3. Provider calls AuthRepository
// 4. Repository verifies password and returns (success, message)
// 5. Provider updates state and calls notifyListeners()
// 6. Consumer widgets rebuild

if (success) {
  // 7. Navigate to home
  Navigator.of(context).pushReplacementNamed('/home');
} else {
  // 8. Show error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(context.read<AuthProvider>().errorMessage ?? ''),
    ),
  );
}
```

### Complete Booking Flow

```dart
// 1. User selects movie, showtime, seats
context.read<BookingProvider>().selectMovie(movie);
context.read<BookingProvider>().selectShowtime('20:00');
context.read<BookingProvider>().setSeatCount(2);

// 2. Check availability
final available = DatabaseService.getAvailableSeats(
  'hall-a',
  movie.id,
  DateTime.now(),
  '20:00',
);

// 3. Confirm booking
final bookingSuccess = await context
    .read<BookingProvider>()
    .confirmBooking();

if (bookingSuccess) {
  // 4. Save reservation
  final reservation = Reservation(
    id: const Uuid().v4(),
    filmName: movie.title,
    sessionTime: '20:00',
    salle: 'Hall A',
    seats: 2,
    totalPrice: movie.price * 2,
    createdAt: DateTime.now(),
    language: movie.language,
    moviePosterUrl: movie.posterUrl,
  );

  await context.read<ReservationProvider>()
      .addReservation(reservation);

  // 5. Show success
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Booking confirmed!')),
  );
}
```

---

**Last Updated**: April 2026
**Version**: 1.0.0

