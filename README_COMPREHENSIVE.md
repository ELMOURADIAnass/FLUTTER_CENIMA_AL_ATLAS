# Cinéma Al-ATLAS - Flutter Cinema Booking Application

A modern, feature-rich cinema booking application built with Flutter that showcases Moroccan and international films with an elegant dark theme UI.

---

## 📱 Project Overview

**Cinéma Al-ATLAS** is a mobile cinema management application that enables users to:
- Browse a curated collection of Moroccan and international films
- View detailed movie information (director, synopsis, rating, showtimes)
- Make movie reservations for specific screenings
- Manage user authentication and profiles
- Track reservation history
- Support multiple languages (French, English, Arabic)

The application is built with a focus on user experience, featuring a premium dark theme with cinema-gold accents, smooth animations, and comprehensive booking functionality.

### Key Features
- **Movie Catalog**: Browse movies by category (Moroccan, International, Classics, New Releases)
- **Authentication System**: Secure user registration and login with password hashing
- **Reservation Management**: Book movie tickets with seat selection and pricing
- **Multi-Language Support**: Full localization in French, English, and Arabic
- **Screening Schedule**: View cinema showtimes organized by movie and time
- **Reservation History**: Track all past and current reservations
- **Responsive Design**: Optimized UI for various screen sizes
- **Dark Theme**: Premium cinema-inspired black and gold aesthetic

---

## 🛠️ Tech Stack

### Core Framework
- **Framework**: Flutter 3.11.1+
- **Language**: Dart
- **Minimum SDK**: Dart SDK 3.11.1 or higher

### State Management & Dependency Injection
- **Provider** (^6.1.2): State management using ChangeNotifier pattern for scalability
- **MultiProvider**: Manages multiple providers (Movie, Auth, Booking, Reservation, Language)

### Local Data Persistence
- **Hive** (^2.2.3): Lightweight, fast local database for user data and reservations
- **Hive Flutter** (^1.1.0): Flutter integration for Hive
- **Path Provider** (^2.1.2): Access app-specific directories for data storage

### UI & Design
- **Material Design**: Google Material Design components
- **Google Fonts** (^6.2.1): Custom typography with Google Font integration
- **Flutter Staggered Animations** (^1.1.1): Smooth entrance animations for movie cards and UI elements

### Utilities & Helpers
- **Intl** (^0.20.2): Internationalization and localization support
- **UUID** (^4.0.0): Unique identifier generation for reservations and users
- **Crypto** (^3.0.3): Password hashing for secure authentication
- **Flutter Localizations**: Built-in Flutter localization delegates

### Development Dependencies
- **Flutter Lints** (^6.0.0): Code quality and style checking
- **Flutter Test**: Unit and widget testing framework

---

## 🏗️ Project Architecture

The application follows a **layered architecture** combining **Provider Pattern** for state management with **Clean Architecture** principles.

### Architecture Layers

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│    (Screens, Widgets, UI Components)    │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│         State Management Layer           │
│  (Providers: Auth, Movie, Booking, etc) │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           Service Layer                  │
│  (Auth Repository, Database Service)    │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           Data/Model Layer               │
│     (Models, Repositories, Database)    │
└─────────────────────────────────────────┘
```

### Design Patterns Used

1. **Provider Pattern**: ChangeNotifier-based state management for reactive UI updates
2. **Repository Pattern**: Centralized data access through AuthRepository and DatabaseService
3. **Singleton Pattern**: Database service initialized once at app startup
4. **Immutability**: Data models use `copyWith()` methods for safe state updates
5. **Dependency Injection**: MultiProvider at root level for global access

---

## 📂 Project Structure

```
cinima_atlas/
├── lib/
│   ├── main.dart                          # App entry point with MultiProvider setup
│   ├── models/                            # Data models
│   │   ├── movie.dart                    # Movie, Screening, Booking, MovieCategory
│   │   ├── user.dart                     # User authentication model
│   │   ├── reservation.dart              # User reservation/booking model
│   │   ├── room.dart                     # Cinema room/hall model
│   │   └── movie_local.dart              # Local movie metadata
│   ├── providers/                         # State management (ChangeNotifier)
│   │   ├── auth_provider.dart            # Authentication state & methods
│   │   ├── movie_provider.dart           # Movie listing & filtering
│   │   ├── booking_provider.dart         # Booking/reservation state
│   │   ├── reservation_provider.dart     # Reservation persistence
│   │   └── language_provider.dart        # Localization state
│   ├── screens/                           # UI Screens
│   │   ├── home_screen.dart              # Main screen with all sections
│   │   ├── login_screen.dart             # User authentication
│   │   ├── signup_screen.dart            # User registration
│   │   ├── movie_list_screen.dart        # Movie catalog view
│   │   ├── movie_detail_screen.dart      # Individual movie details
│   │   ├── reservation_history_screen.dart # User's bookings history
│   │   └── local_movie_list_screen.dart  # Local/uploaded movies
│   ├── widgets/                           # Reusable UI components
│   │   ├── movie_card.dart               # Movie tile with animation
│   │   ├── booking_modal.dart            # Modal for making reservations
│   │   ├── screening_table.dart          # Schedule table display
│   │   ├── filter_tabs.dart              # Category filter tabs
│   │   ├── testimonial_card.dart         # User review cards
│   │   ├── section_title.dart            # Section headers
│   │   ├── app_image_widget.dart         # Image display with caching
│   │   └── language_switcher.dart        # Language selection widget
│   ├── services/                          # Business logic & data access
│   │   ├── auth_repository.dart          # Authentication logic (login, register)
│   │   ├── database_service.dart         # Hive database operations
│   │   └── api_service.dart              # (Optional) External API calls
│   ├── utils/                             # Helper functions & constants
│   │   ├── theme.dart                    # App colors, themes, styling
│   │   ├── constants.dart                # App-wide constants
│   │   ├── movie_database.dart           # Centralized movie data
│   │   └── app_images.dart               # Image asset mappings
│   ├── l10n/                              # Localization files
│   │   ├── intl_en.arb                   # English translations
│   │   ├── intl_fr.arb                   # French translations
│   │   └── intl_ar.arb                   # Arabic translations
│   └── data/                              # Static data & fixtures
├── assets/                                # Static assets
│   ├── images/
│   │   ├── posters/                      # Movie poster images
│   │   └── icons/                        # Icon assets
├── test/                                  # Unit & Widget tests
├── android/                               # Android-specific config
├── ios/                                   # iOS-specific config
├── pubspec.yaml                           # Dependencies & config
└── README.md                              # Project documentation
```

### File Descriptions

#### Models (`lib/models/`)
- **movie.dart**: Core Movie class, Screening, Booking, and MovieCategory enum
  - Movie: Title, director, rating, price, showtimes, category
  - Screening: Session-specific information
  - Booking: Customer reservation details with status tracking
  - MovieCategory: Enum for filtering (Moroccan, International, Classics, New)

- **user.dart**: User authentication model with secure password storage
  - Implements `toMap()`/`fromMap()` for Hive persistence
  - Supports profile updates and password changes

- **reservation.dart**: User booking history model
  - Stores reservation details with timestamps
  - Integrates with Hive for persistent storage

- **room.dart**: Cinema hall/screening room information
  - Hall ID, name, seating capacity, layout type
  - Used for seat availability calculation

#### Providers (`lib/providers/`)
- **auth_provider.dart**: Manages authentication state
  - Methods: `login()`, `register()`, `logout()`, `updateProfile()`, `changePassword()`
  - Tracks loading state and error messages
  - Integrates with AuthRepository for business logic

- **movie_provider.dart**: Manages movie catalog and filtering
  - Maintains selected category filter
  - Provides `filteredMovies`, `featuredMovies`, and search methods
  - Emits updates when category changes

- **booking_provider.dart**: Manages active booking state
  - Tracks selected movie, showtime, seats, and total price
  - Validates availability before confirmation

- **reservation_provider.dart**: Handles persistent reservation storage
  - Loads/saves reservations from Hive
  - Manages reservation list and history
  - Provides filtering and retrieval methods

- **language_provider.dart**: Manages app localization
  - Tracks current language/locale
  - Notifies UI to rebuild with new language

#### Screens (`lib/screens/`)
- **home_screen.dart**: Landing page with multiple sections
  - Hero banner with cinema branding
  - Featured movies carousel
  - Screening schedule table
  - User testimonials
  - Contact information
  - Navigation scroll sync

- **login_screen.dart**: User authentication interface
  - Email and password input validation
  - Integration with AuthProvider
  - Signup navigation

- **movie_list_screen.dart**: Full movie catalog
  - Category filtering with tabs
  - Search functionality
  - Grid or list view toggle
  - Movie card tapping navigates to detail view

- **movie_detail_screen.dart**: Individual movie information
  - Full synopsis and metadata
  - Available showtimes
  - Booking modal trigger
  - User ratings and reviews

- **reservation_history_screen.dart**: User's booking history
  - Lists all reservations with details
  - Cancellation capability
  - Filters by date or status

#### Widgets (`lib/widgets/`)
- **movie_card.dart**: Reusable movie display tile
  - Poster image with rating badge
  - Title and director info
  - Staggered entrance animation

- **booking_modal.dart**: Modal dialog for making reservations
  - Seat count selector
  - Showtime selection
  - Price calculation
  - Confirmation with validation

- **screening_table.dart**: Schedule table display
  - Movies organized by time slots
  - Hall/room information
  - Availability status

- **filter_tabs.dart**: Category filter UI
  - Tab navigation between categories
  - Active state indication

#### Services (`lib/services/`)
- **auth_repository.dart**: Authentication business logic
  - User registration with validation
  - Login with password verification
  - Profile updates
  - Password changes with hashing (using crypto package)
  - Session management with Hive

- **database_service.dart**: Hive database operations
  - Initialize Hive with flutter support
  - Manage rooms box and bookings box
  - Seed default cinema halls
  - Query seat availability
  - Track booked seats per screening

#### Utilities (`lib/utils/`)
- **theme.dart**: Complete design system
  - Colors: Dark background, cinema gold accents
  - Typography: Font sizes and weights
  - Component themes: Buttons, cards, inputs
  - Responsive breakpoints

- **constants.dart**: App-wide constants
  - API endpoints (if applicable)
  - Configuration values
  - String constants

- **movie_database.dart**: Centralized movie data source
  - Static list of 15+ movies
  - Factory methods for querying (by ID, category, price range)
  - Search functionality
  - Sorting by rating and price

- **app_images.dart**: Image asset path mappings
  - Local poster image references
  - Network image URLs
  - Fallback image URLs

---

## 💾 Database

### Database Technology: Hive

**Hive** is a lightweight, NoSQL database optimized for Flutter applications. It provides:
- Zero-configuration setup
- Type-safe operations
- Fast read/write speeds
- Automatic persistence to device storage

### Database Schema

#### Boxes (Collections)

1. **`users` Box**
   - Stores user account information
   - Key: User ID (UUID)
   - Value: User map with email, name, hashed password, timestamps

   ```dart
   {
     'id': 'uuid-string',
     'email': 'user@example.com',
     'fullName': 'John Doe',
     'hashedPassword': 'hashed_string',
     'createdAt': '2024-01-15T10:30:00.000Z',
     'lastLogin': '2024-01-20T15:45:00.000Z'
   }
   ```

2. **`reservations` Box**
   - Stores user booking history
   - Key: Reservation ID (UUID)
   - Value: Reservation details with screening info

   ```dart
   {
     'id': 'reservation-uuid',
     'filmName': 'Adam',
     'sessionTime': '20:00',
     'salle': 'Hall A',
     'seats': 3,
     'totalPrice': 180.0,
     'createdAt': '2024-01-20T15:45:00.000Z',
     'language': 'FR',
     'moviePosterUrl': 'asset://images/posters/adam.jpg'
   }
   ```

3. **`rooms` Box**
   - Stores cinema hall configurations
   - Key: Room ID
   - Value: Room specifications

   ```dart
   {
     'id': 'hall-a',
     'name': 'Salle A',
     'capacity': 150,
     'layoutType': 'standard'
   }
   ```

4. **`bookings` Box**
   - Tracks seat availability per screening
   - Key: Composite key (movieId_roomId_date_time)
   - Value: Number of booked seats

   ```
   '1_hall-a_2024-01-20_20:00' -> 45 (booked seats)
   ```

### Data Persistence Flow

```
User Input (Login/Booking)
         ↓
Provider Updates State
         ↓
Service Layer Validation
         ↓
AuthRepository / DatabaseService
         ↓
Hive Box Operations
         ↓
Device File System (Encrypted)
```

### Authentication Security

- Passwords are **hashed using the `crypto` package** (PBKDF2 or SHA-256)
- Plain text passwords are never stored
- Session tokens are stored in Hive with timestamp validation
- Password changes require verification of current password

---

## 🎨 UI / UX Design

### Design System

The application implements a **Premium Cinema Dark Theme** with the following design language:

#### Color Palette
```
Primary Background:    #000000 (Pure Black)
Surface Color:         #1A1A1A (Dark Gray)
Accent Color:          #F4C518 (Cinema Gold)
Text Primary:          #FFFFFF (White)
Text Secondary:        #A1A1A1 (Light Gray)
Text Tertiary:         #767676 (Muted Gray)
```

#### Typography
- **Headlines**: Google Font 'Roboto' (32px bold for H1, 28px for H2)
- **Body Text**: Google Font 'Roboto' (16px regular)
- **Captions**: 12px secondary color

#### Component Styling
- **Buttons**: Gold background (#F4C518) with dark text, 12px corner radius
- **Cards**: Dark surface with subtle borders, 8px radius
- **Input Fields**: Dark background, gold border on focus
- **Navigation**: Bottom navigation or custom navbar with scroll-sync support

### User Interface Screens

#### 1. **Login Screen**
- Email and password input fields
- Form validation
- Login and signup buttons
- Password reset link
- Session persistence via AuthProvider

#### 2. **Home Screen** (Main Dashboard)
Multiple scrollable sections:

a. **Hero Banner**
   - Cinema branding and call-to-action
   - Background image or gradient

b. **Featured Movies Section**
   - Horizontal carousel of 4 featured films
   - Quick booking action buttons
   - Staggered entrance animation

c. **Screening Schedule**
   - Table showing all showtimes by movie and hall
   - Time, movie title, hall, availability
   - Clickable rows for detailed booking

d. **Movie Catalog**
   - Category filter tabs (All, Moroccan, International, etc.)
   - Grid view of movies
   - Movie cards with poster, title, rating, price
   - Tap to view details

e. **Testimonials Section**
   - User review cards
   - Star ratings
   - Carousel of reviews

f. **Contact & Footer**
   - Cinema contact information
   - Social media links
   - Legal links

#### 3. **Movie Detail Screen**
- Large poster image
- Full metadata (director, year, duration, genre)
- Complete synopsis
- User rating and review count
- Available showtimes with halls
- "Book Now" button opens booking modal

#### 4. **Booking Modal**
- Movie and showtime display
- Seat count selector (spinner or input)
- Price calculation (seats × price per seat)
- Confirm/Cancel buttons
- Success notification after booking

#### 5. **Reservation History Screen**
- List of all user reservations
- Each item shows: movie, date, time, hall, seats, price
- Cancellation option with confirmation
- Filter/sort options (by date, status)

### Navigation Flow

```
Login/Signup Screen
       ↓
Home Screen (Main Hub)
    ├─→ Browse Movies
    │   └─→ Movie Details
    │       └─→ Booking Modal
    ├─→ View Schedule
    ├─→ Reservation History
    └─→ Profile/Settings
```

### Responsive Design
- Optimized for mobile (320px - 600px width)
- Tablet support (600px - 1200px width)
- Adaptive layouts using MediaQuery
- Bottom navigation on mobile, sidebar on tablet

---

## 🔑 Key Components & Responsibilities

### Core Business Logic Classes

#### **Movie Model**
- Represents a cinema film with all metadata
- Properties: id, title, director, year, duration, rating, genre, synopsis, posterUrl, price, category, language, showtimes
- Methods: `copyWith()` for immutable updates
- Used throughout the app for data display and filtering

#### **MovieProvider** (State Management)
- Responsibilities:
  - Maintain movie catalog
  - Track selected category filter
  - Provide filtered/featured movie lists
  - Emit notifications on filter changes
- Key methods:
  - `setCategory(MovieCategory)` - Update filter
  - `getMovieById(String id)` - Retrieve specific movie
  - Getter: `filteredMovies`, `featuredMovies`

#### **Booking Model & BookingProvider**
- Booking model stores reservation details with seat count and pricing
- BookingProvider manages:
  - Current booking in progress
  - Seat availability checking
  - Price calculation
  - Booking confirmation

#### **AuthProvider** (State Management)
- Responsibilities:
  - Authentication state management
  - User registration and login
  - Profile updates
  - Password management
  - Session persistence
- Key methods:
  - `login(email, password)` → Future<bool>
  - `register(email, password, fullName)` → Future<bool>
  - `logout()` → Future<void>
  - `updateProfile(fullName)` → Future<bool>
  - `changePassword(currentPassword, newPassword)` → Future<bool>
- Properties:
  - `isLoggedIn` - Getter to check auth status
  - `currentUser` - Current User object
  - `errorMessage` - Last error message
  - `isLoading` - Loading state during async operations

#### **AuthRepository** (Service Layer)
- Bridges AuthProvider with Hive database
- Responsibilities:
  - User registration with validation
  - Password hashing and verification
  - User lookup by email
  - Session management
- Key methods:
  - `register(email, password, fullName)` → (success, message) tuple
  - `login(email, password)` → (success, message) tuple
  - `getCurrentUser()` → User?
  - `logout()` → Future<void>

#### **DatabaseService** (Service Layer)
- Manages Hive database operations for rooms and bookings
- Responsibilities:
  - Initialize Hive database
  - Manage cinema halls/rooms data
  - Track seat availability per screening
  - Persist booking records
- Key methods:
  - `initialize()` - Setup Hive on startup
  - `getAllRooms()` → List<Room>
  - `getAvailableSeats(roomId, movieId, date, time)` → int
  - `bookSeats(roomId, movieId, date, time, seats)` → Future<bool>

#### **ReservationProvider** (State Management)
- Manages user reservation history with Hive persistence
- Responsibilities:
  - Load reservations from storage
  - Add new reservations
  - Delete/cancel reservations
  - Track reservation count
  - Emit notifications on changes
- Key methods:
  - `addReservation(Reservation)` → Future<void>
  - `deleteReservation(id)` → Future<void>
  - `searchByMovie(title)` → List<Reservation>
  - Getter: `reservations`, `hasReservations`, `reservationCount`

#### **LanguageProvider** (State Management)
- Manages app localization
- Responsibilities:
  - Track current language/locale
  - Trigger UI rebuild on language change
  - Provide locale to MaterialApp
- Supported locales: French (fr), English (en), Arabic (ar)

### Widget Components

#### **MovieCard**
- Displays movie poster, title, rating
- OnTap navigates to detail screen
- Uses staggered animation for entrance effect
- Responsive sizing

#### **BookingModal**
- Modal dialog for making reservations
- Seat count input
- Showtime selection
- Real-time price calculation
- Form validation before submission

#### **ScreeningTable**
- Tabular display of all screenings
- Columns: Movie, Time, Hall, Availability
- Row selection for booking
- Responsive table layout

#### **FilterTabs**
- Tab navigation for movie categories
- Visual indicator of active category
- OnTap updates MovieProvider

---

## 🚀 Installation & Setup

### Prerequisites
- **Flutter SDK**: Version 3.11.1 or higher
  - Download from: https://flutter.dev/docs/get-started/install
- **Dart SDK**: Included with Flutter (3.11.1+)
- **Android Studio** or **VS Code** with Flutter extension
- **Device or Emulator**: Android device/emulator for testing

### Step 1: Clone the Repository
```bash
git clone https://github.com/yourusername/cinima_atlas.git
cd cinima_atlas
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

This installs all packages defined in `pubspec.yaml`:
- Provider for state management
- Hive for local storage
- Google Fonts for typography
- Intl for localization
- And all other dependencies

### Step 3: Configure Android (if building for Android)

#### Option A: Using Android Studio
1. Open `android/` folder in Android Studio
2. Let Gradle sync automatically
3. Build runs APK for connected device

#### Option B: Using Command Line
```bash
flutter devices  # List connected devices
flutter run     # Install and run on default device
flutter run -d {device_id}  # Run on specific device
```

### Step 4: iOS Setup (Optional, for iOS deployment)
```bash
cd ios
pod install
cd ..
flutter run  # Build and run on iOS simulator
```

### Step 5: Run Development Build
```bash
# Debug build
flutter run

# Release build
flutter build apk --release

# iOS release
flutter build ios --release
```

### Step 6: Run Tests (Optional)
```bash
flutter test  # Run all unit and widget tests
```

### Important Setup Notes
- **Hive Initialization**: Database service initializes automatically in `main()` before `runApp()`
- **MultiProvider Setup**: All providers are registered in `main.dart` root widget
- **Locale Support**: App automatically uses device locale (falls back to French if unsupported)
- **Theme**: Dark theme is applied globally via `AppTheme.darkTheme`

---

## 📝 Notes for Developers

### Important Architecture Decisions

1. **Provider Pattern Over BLoC**
   - Chosen for simplicity and faster development
   - ChangeNotifier is lightweight and sufficient for this app scale
   - Easy to understand for new team members
   - Alternative: Consider BLoC for larger, more complex apps

2. **Hive Over Other Databases**
   - No need for relational database (Firebase)
   - Hive offers fast, offline-first local storage
   - Zero configuration required
   - Manual serialization (toMap/fromMap) ensures explicit control

3. **Manual Authentication Over Firebase**
   - Fine-grained control over security implementation
   - Learn cryptographic best practices
   - Avoid external dependencies for authentication
   - Trade-off: More implementation responsibility

4. **Immutable Data Models**
   - All models are effectively immutable using `copyWith()`
   - Prevents accidental state mutations
   - Ensures predictable data flow
   - Integrates well with Provider pattern

5. **Centralized Movie Database**
   - Static `MovieDatabase.dart` provides centralized data source
   - Factory methods for common queries
   - Easier to mock for testing
   - Ready for API integration when needed

### Code Quality Guidelines

1. **Naming Conventions**
   - Classes: PascalCase (e.g., `MovieProvider`)
   - Methods/Variables: camelCase (e.g., `selectedCategory`)
   - Constants: camelCase with leading underscore for private (e.g., `_movies`)
   - Files: snake_case (e.g., `auth_provider.dart`)

2. **State Management**
   - Providers should only manage state, not contain business logic
   - Use Services (Repository, Database) for business logic
   - Always call `notifyListeners()` after state changes
   - Dispose controllers/listeners in `dispose()` method

3. **Error Handling**
   - Use try-catch in providers with meaningful error messages
   - Display errors to user via UI, not console
   - Log errors for debugging (use debugPrint)
   - Return tuples (success, message) from repositories

4. **Testing Strategy**
   - Unit tests for models and repositories
   - Widget tests for UI components
   - Integration tests for full user flows
   - Use `mockito` package for mocking dependencies

### Common Tasks

#### Adding a New Screen
1. Create `{screen_name}_screen.dart` in `lib/screens/`
2. Extend `StatelessWidget` or `StatefulWidget`
3. Use `Consumer<Provider>` to access state
4. Add route to `main.dart` routes map
5. Implement navigation from existing screen

#### Adding a New Feature
1. Define Model in `lib/models/`
2. Create Provider in `lib/providers/` if state needed
3. Create Service/Repository in `lib/services/` if business logic
4. Build Widgets in `lib/screens/` or `lib/widgets/`
5. Integrate with existing providers via MultiProvider

#### Adding Localization
1. Edit `lib/l10n/intl_*.arb` files (en, fr, ar)
2. Add translation keys and values
3. Use `AppLocalizations.of(context)?.key` to access
4. Run `flutter gen-l10n` to generate localization classes

#### Database Queries
```dart
// Add/Update
await DatabaseService.saveRoom(room);

// Retrieve
final room = DatabaseService.getRoomById('hall-a');
final allRooms = DatabaseService.getAllRooms();

// Delete
await DatabaseService.deleteRoom('hall-a');
```

### Performance Optimization Tips

1. **Image Loading**
   - Use `CachedNetworkImage` for network images
   - Provide fallback placeholder
   - Set appropriate image resolution

2. **List Rendering**
   - Use `ListView.builder()` with `shrinkWrap: true` for bounded lists
   - Implement `AnimationController` cleanup
   - Lazy load data when possible

3. **State Updates**
   - Only rebuild necessary widgets using `Consumer`
   - Avoid `Consumer` wrapping entire tree
   - Use `selector` for granular state listening

4. **Database Access**
   - Cache frequently accessed data
   - Batch operations when possible
   - Close boxes on app termination

### Known Limitations & Future Improvements

1. **Current Limitations**
   - No push notifications for booking confirmations
   - No payment gateway integration (assume cash/on-site payment)
   - No real-time seat availability updates across devices
   - No image caching implementation

2. **Future Enhancement Ideas**
   - Integration with payment provider (Stripe, PayPal)
   - Real-time seat availability via WebSocket
   - Movie review/rating system
   - Loyalty program and discount codes
   - Email notifications for bookings
   - Admin panel for managing movies and screenings
   - Analytics and user behavior tracking

### Troubleshooting Common Issues

**Issue: "Box not found" from Hive**
- Solution: Ensure `DatabaseService.initialize()` is called in `main()` before `runApp()`

**Issue: Providers not notifying widgets**
- Solution: Ensure `notifyListeners()` is called after state changes

**Issue: Images not loading from assets**
- Solution: Verify paths in `pubspec.yaml` and use exact paths in code

**Issue: Localization not working**
- Solution: Run `flutter gen-l10n` after editing `.arb` files

**Issue: Hive boxes opening twice**
- Solution: Use static box references to avoid duplicate opens

---

## 📞 Support & Contact

For questions or issues, please refer to:
- Flutter Documentation: https://flutter.dev/docs
- Provider Package: https://pub.dev/packages/provider
- Hive Documentation: https://docs.hivedb.dev/

---

## 📄 License

This project is provided as-is for educational and commercial use.

---

## 🙏 Acknowledgments

- Built with Flutter and Dart
- Uses Material Design from Google
- Inspired by modern cinema booking applications
- Special thanks to the open-source Flutter community

---

**Last Updated**: April 2026
**Version**: 1.0.0
**Status**: Production Ready

