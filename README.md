# Cinéma Al-ATLAS - Flutter Cinema Booking Application

A modern, feature-rich cinema booking application built with Flutter that showcases Moroccan and international films with an elegant dark theme UI.

## 📱 Project Overview

**Cinéma Al-ATLAS** is a mobile cinema management application that enables users to browse movies, make reservations, and manage their bookings with support for multiple languages (French, English, Arabic).

### Key Features
- 🎬 **Movie Catalog**: Browse Moroccan and international films organized by categories
- 🎟️ **Reservation System**: Book movie tickets with real-time seat availability
- 👤 **User Authentication**: Secure registration and login with password hashing
- 📅 **Screening Schedule**: View all showtimes organized by movie and cinema hall
- 🌍 **Multi-Language Support**: Full localization in French, English, and Arabic
- 🎨 **Premium UI**: Dark theme with cinema gold accents and smooth animations
- 📱 **Responsive Design**: Optimized for mobile and tablet devices

---

## 🛠️ Tech Stack

### Core Framework
- **Flutter 3.11.1+** - Cross-platform mobile framework
- **Dart** - Programming language

### State Management
- **Provider (^6.1.2)** - State management using ChangeNotifier pattern

### Local Data Persistence
- **Hive (^2.2.3)** - Lightweight, fast local database
- **Hive Flutter (^1.1.0)** - Flutter integration

### UI & Design
- **Material Design** - Google Material components
- **Google Fonts (^6.2.1)** - Custom typography
- **Flutter Staggered Animations (^1.1.1)** - Smooth entrance animations

### Utilities
- **Intl (^0.20.2)** - Internationalization support
- **UUID (^4.0.0)** - Unique identifier generation
- **Crypto (^3.0.3)** - Password hashing for security
- **Path Provider (^2.1.2)** - App-specific directory access

---

## 🏗️ Project Architecture

The application follows a **layered architecture** with **Provider Pattern** for state management:

```
Presentation Layer (Screens, Widgets)
          ↓
State Management Layer (Providers)
          ↓
Service Layer (Repositories, Database)
          ↓
Data/Model Layer (Models)
```

### Design Patterns
- **Provider Pattern**: Reactive state management with ChangeNotifier
- **Repository Pattern**: Centralized data access
- **Singleton Pattern**: Database service initialization
- **Immutability**: Safe state updates with `copyWith()` methods

---

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point with MultiProvider setup
├── models/                      # Data models
│   ├── movie.dart              # Movie, Screening, Booking models
│   ├── user.dart               # User authentication model
│   ├── reservation.dart        # Reservation/booking persistence
│   └── room.dart               # Cinema hall model
├── providers/                   # State management (ChangeNotifier)
│   ├── auth_provider.dart      # Authentication state
│   ├── movie_provider.dart     # Movie listing & filtering
│   ├── booking_provider.dart   # Booking state management
│   ├── reservation_provider.dart # Reservation persistence
│   └── language_provider.dart  # Localization state
├── screens/                     # UI Screens
│   ├── home_screen.dart        # Main screen with all sections
│   ├── login_screen.dart       # User authentication
│   ├── movie_list_screen.dart  # Movie catalog
│   ├── movie_detail_screen.dart# Movie details & booking
│   └── reservation_history_screen.dart # User's bookings
├── widgets/                     # Reusable UI components
│   ├── movie_card.dart         # Movie tile
│   ├── booking_modal.dart      # Reservation modal
│   ├── screening_table.dart    # Schedule display
│   └── filter_tabs.dart        # Category filters
├── services/                    # Business logic
│   ├── auth_repository.dart    # Authentication logic
│   └── database_service.dart   # Hive database operations
└── utils/                       # Helpers & constants
    ├── theme.dart              # Design system & colors
    ├── constants.dart          # App-wide constants
    ├── movie_database.dart     # Centralized movie data
    └── app_images.dart         # Image asset mappings
```

---

## 💾 Database

**Hive** is used for local data persistence with the following boxes:

### Data Structure
- **Users Box**: User accounts with hashed passwords
- **Reservations Box**: Booking history with session details
- **Rooms Box**: Cinema hall configurations and capacity
- **Bookings Box**: Seat availability tracking per screening

All models implement `toMap()`/`fromMap()` for Hive serialization.

---

## 🎨 UI / UX Design

### Design System
- **Color Palette**: Black background with cinema gold (#F4C518) accents
- **Typography**: Google Roboto font for consistent style
- **Animations**: Staggered entrance effects and smooth transitions
- **Responsive**: Optimized for mobile (320px - 600px) and tablet (600px+)

### Main Screens
1. **Login Screen** - User authentication
2. **Home Screen** - Featured movies, schedule, testimonials
3. **Movie List** - Catalog with category filtering
4. **Movie Detail** - Full info and booking interface
5. **Reservation History** - User's booking management

---

## 🔑 Key Components

### State Management Providers
- **AuthProvider**: User authentication and profile management
- **MovieProvider**: Movie catalog and filtering
- **BookingProvider**: Current booking state
- **ReservationProvider**: Booking history with persistence
- **LanguageProvider**: App localization (FR, EN, AR)

### Core Services
- **AuthRepository**: Registration, login, password management
- **DatabaseService**: Hive operations for rooms and bookings

### Data Models
- **Movie**: Film information with pricing and showtimes
- **User**: User account with secure password storage
- **Reservation**: Booking details with timestamps
- **Room**: Cinema hall capacity and layout

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** 3.11.1+
- **Dart SDK** 3.11.1+
- Android device/emulator or iOS simulator

### Installation

1. **Clone Repository**
   ```bash
   git clone https://github.com/yourusername/cinima_atlas.git
   cd cinima_atlas
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Application**
   ```bash
   flutter run
   ```

4. **Build Release APK** (Android)
   ```bash
   flutter build apk --release
   ```

5. **Build Release IPA** (iOS)
   ```bash
   flutter build ios --release
   ```

### Configuration
- Database initializes automatically in `main()`
- All providers registered in MultiProvider setup
- Default locale from device settings

---

## 📝 Developer Notes

### Architecture Highlights
- **Provider Pattern** chosen for simplicity and scalability
- **Hive Database** for zero-configuration local storage
- **Manual Authentication** for fine-grained security control
- **Immutable Models** using `copyWith()` for safe updates

### Important Practices
1. Always call `notifyListeners()` after state changes
2. Use `Consumer` widgets for granular rebuilds
3. Implement `dispose()` for cleanup in StatefulWidgets
4. Handle errors gracefully with user-friendly messages
5. Use `debugPrint()` for logging during development

### Adding New Features
1. Define Model in `lib/models/`
2. Create Provider in `lib/providers/` if needed
3. Implement Service in `lib/services/`
4. Build Widgets in `lib/screens/` or `lib/widgets/`
5. Test with both unit and widget tests

---

## 🔐 Security Features

- **Password Hashing**: Passwords secured with crypto package (PBKDF2/SHA-256)
- **Session Management**: Token-based sessions stored in Hive
- **Input Validation**: Form validation on all user inputs
- **Immutable State**: Prevents unauthorized state mutations

---

## 🌐 Localization

The app supports three languages via the `intl` package:
- **French** (fr) - Default
- **English** (en)
- **Arabic** (ar)

Language selection persists via LanguageProvider.

---

## 📊 Performance

- **Lazy Loading**: ListView.builder for efficient list rendering
- **Image Caching**: Network image optimization
- **State Optimization**: Granular provider updates with Consumer widgets
- **Database**: Hive for fast, offline-first operations

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:
1. Create a feature branch
2. Make your changes
3. Write tests for new features
4. Submit a pull request

---

## 📞 Support

For issues or questions:
- Check [Flutter Documentation](https://flutter.dev/docs)
- Review [Provider Package Docs](https://pub.dev/packages/provider)
- See [Hive Documentation](https://docs.hivedb.dev/)

---

## 📄 License

This project is provided as-is for educational and commercial use.

---

## 🙏 Acknowledgments

Built with Flutter and Dart, inspired by modern cinema booking applications.

---

**Version**: 1.0.0  
**Status**: Production Ready  
**Last Updated**: April 2026
