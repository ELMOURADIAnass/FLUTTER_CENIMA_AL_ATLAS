# Reservations Feature - Quick Integration Guide

## How It Works

### 1. **Booking Flow**
```
User Books Movie
    ↓
BookingModal._confirmBooking() executes
    ↓
Creates Booking object (existing logic)
    ↓
Creates Reservation object (NEW)
    ↓
Saves to ReservationProvider (NEW)
    ↓
Stored in Hive database (NEW)
    ↓
Success feedback
```

### 2. **Viewing Reservations**
```
User clicks "Reservations" in navbar
    ↓
Navigates to ReservationHistoryScreen
    ↓
ReservationProvider loads from Hive
    ↓
Display sorted list (latest first)
    ↓
User can delete with swipe gesture
```

## Code Structure

### Reservation Model
```dart
class Reservation {
  final String id;
  final String filmName;
  final String sessionTime;
  final String salle;
  final int seats;
  final double totalPrice;
  final DateTime createdAt;
  final String language;
  final String moviePosterUrl;
  
  // ... toMap(), fromMap(), copyWith()
}
```

### ReservationProvider Methods
```dart
// Initialize from storage
Future<void> initialize()

// Add new reservation
Future<void> addReservation(Reservation reservation)

// Delete reservation
Future<void> deleteReservation(String reservationId)

// Get reservation by ID
Reservation? getReservationById(String id)

// Clear all
Future<void> clearAllReservations()

// Refresh from storage
Future<void> refresh()
```

## File Locations

```
lib/
├── models/
│   └── reservation.dart          [NEW] Reservation model
├── providers/
│   ├── reservation_provider.dart  [NEW] State management
│   └── ...
├── screens/
│   ├── home_screen.dart           [UPDATED] Added navbar button
│   └── reservation_history_screen.dart [NEW] Display screen
├── widgets/
│   ├── booking_modal.dart         [UPDATED] Save to provider
│   └── ...
├── utils/
│   └── localization.dart          [UPDATED] Added strings
└── main.dart                      [UPDATED] Added provider
```

## Key Integration Points

### 1. In `main.dart`
```dart
ChangeNotifierProvider(create: (_) => _reservationProvider),
```

### 2. In `home_screen.dart`
```dart
_buildNavItem(localizations.reservations, 
  () => _navigateToReservations(context), false),
```

### 3. In `booking_modal.dart`
```dart
final reservation = Reservation(
  id: booking.id,
  filmName: widget.movie.title,
  sessionTime: selectedTime!,
  salle: selectedRoom!.name,
  seats: selectedSeats,
  totalPrice: widget.movie.price * selectedSeats,
  createdAt: DateTime.now(),
  language: widget.movie.language,
  moviePosterUrl: widget.movie.posterUrl,
);
await context.read<ReservationProvider>().addReservation(reservation);
```

## Database

**Storage**: Hive Box named `reservations`

**Key Format**: `booking_${timestamp}`

**Data Format**: Map<String, dynamic>

```dart
{
  'id': 'booking_1234567890',
  'filmName': 'Adam',
  'sessionTime': '20:00',
  'salle': 'Salle 1',
  'seats': 2,
  'totalPrice': 120.0,
  'createdAt': '2024-04-22T20:30:00.000000',
  'language': 'AR/FR',
  'moviePosterUrl': '...'
}
```

## Localization Keys Added

```dart
reservations              // "Mes Reservations"
noReservations            // "Aucune reservation"
noReservationsDesc        // Empty state message
browseMovies              // "Parcourir les films"
reservationDeleted        // "Reservation supprimee"
deleteReservation         // "Supprimer la reservation ?"
deleteReservationConfirm  // Confirmation message
cancel                    // "Annuler"
delete                    // "Supprimer"
```

## UI Components

### ReservationHistoryScreen
- **AppBar**: With back button and title
- **Empty State**: Shows when no reservations
- **ListView**: Animated list of reservations
- **Card**: Each reservation in a beautiful card
  - Movie poster header with gradient
  - Detail grid (time, hall, seats, language, price, date)
  - Swipe to delete
  - Delete confirmation dialog

### Delete Interaction
- **Gesture**: Swipe left to reveal delete
- **Confirmation**: Dialog asking for confirmation
- **Feedback**: SnackBar showing deletion success
- **Animation**: Smooth transition

## State Updates

Provider automatically updates UI when:
1. New reservation added
2. Reservation deleted
3. List refreshed

**Sorting**: Always displays newest first (by `createdAt`)

## Error Handling

- Try-catch in `_confirmBooking()`
- Silent fail on reservation save (doesn't break booking)
- Error dialogs for critical issues
- DebugPrint for troubleshooting

## Future Enhancements

Possible additions:
- Edit reservation functionality
- Cancel reservation with refund logic
- Reservation status (pending, confirmed, expired)
- Email/SMS notifications
- QR code for check-in
- Reservation statistics dashboard
- Export reservations as PDF
- Sync with backend API

