# Reservations Feature - Code Examples

## Example 1: Creating a Reservation Manually

```dart
import 'package:provider/provider.dart';
import 'package:cinima_atlas/models/reservation.dart';
import 'package:cinima_atlas/providers/reservation_provider.dart';

// Example: Save a reservation programmatically
Future<void> createReservationExample(BuildContext context) async {
  final reservation = Reservation(
    id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
    filmName: 'Adam',
    sessionTime: '20:00',
    salle: 'Salle 1',
    seats: 2,
    totalPrice: 120.0,
    createdAt: DateTime.now(),
    language: 'AR/FR',
    moviePosterUrl: 'https://...',
  );
  
  try {
    await context.read<ReservationProvider>().addReservation(reservation);
    print('Reservation saved successfully!');
  } catch (e) {
    print('Error saving reservation: $e');
  }
}
```

## Example 2: Accessing Reservations

```dart
// Get all reservations sorted by latest first
final reservations = context.read<ReservationProvider>().reservations;

// Check if there are any reservations
final hasReservations = context.read<ReservationProvider>().hasReservations;

// Get count
final count = context.read<ReservationProvider>().reservationCount;

// Get specific reservation
final reservation = context.read<ReservationProvider>()
    .getReservationById('booking_1234567890');
```

## Example 3: Building a Simple Reservation Card

```dart
Widget buildReservationCard(Reservation reservation) {
  return Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reservation.filmName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Time: ${reservation.sessionTime}'),
              Text('Hall: ${reservation.salle}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Seats: ${reservation.seats}'),
              Text('Price: ${reservation.totalPrice} DH'),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Booked: ${_formatDate(reservation.createdAt)}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

String _formatDate(DateTime dateTime) {
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}
```

## Example 4: Watch for Changes in UI

```dart
// Auto-update when reservations change
Widget reservationsList(BuildContext context) {
  return Consumer<ReservationProvider>(
    builder: (context, reservationProvider, child) {
      if (!reservationProvider.hasReservations) {
        return Center(
          child: Text('No reservations yet'),
        );
      }
      
      return ListView.builder(
        itemCount: reservationProvider.reservationCount,
        itemBuilder: (context, index) {
          final reservation = reservationProvider.reservations[index];
          return buildReservationCard(reservation);
        },
      );
    },
  );
}
```

## Example 5: Delete Reservation

```dart
// Delete by ID
Future<void> deleteReservation(BuildContext context, String reservationId) async {
  try {
    await context.read<ReservationProvider>()
        .deleteReservation(reservationId);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reservation deleted')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

// Clear all reservations
Future<void> clearAll(BuildContext context) async {
  try {
    await context.read<ReservationProvider>()
        .clearAllReservations();
  } catch (e) {
    print('Error clearing reservations: $e');
  }
}
```

## Example 6: Refresh Data from Storage

```dart
// Manually refresh reservations from Hive storage
Future<void> refreshReservations(BuildContext context) async {
  await context.read<ReservationProvider>().refresh();
}

// Useful when you suspect data might be out of sync
Widget refreshButton(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.refresh),
    onPressed: () => refreshReservations(context),
  );
}
```

## Example 7: Export Reservations as JSON

```dart
import 'dart:convert';

String exportReservationsAsJson(BuildContext context) {
  final reservations = context.read<ReservationProvider>().reservations;
  
  final jsonList = reservations.map((r) => r.toMap()).toList();
  return jsonEncode(jsonList);
}

// Usage: Save to file or send to API
Future<void> exportAndShare(BuildContext context) async {
  final json = exportReservationsAsJson(context);
  print(json);
  // Could integrate with file sharing or API here
}
```

## Example 8: Search Reservations

```dart
// Search reservations by film name
List<Reservation> searchReservations(
  BuildContext context,
  String query,
) {
  final reservations = context.read<ReservationProvider>().reservations;
  
  return reservations
      .where((r) => r.filmName.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

// Filter by date range
List<Reservation> filterByDateRange(
  BuildContext context,
  DateTime start,
  DateTime end,
) {
  final reservations = context.read<ReservationProvider>().reservations;
  
  return reservations
      .where((r) => r.createdAt.isAfter(start) && r.createdAt.isBefore(end))
      .toList();
}
```

## Example 9: Calculate Statistics

```dart
// Get statistics
Map<String, dynamic> getReservationStats(BuildContext context) {
  final reservations = context.read<ReservationProvider>().reservations;
  
  final totalReservations = reservations.length;
  final totalSpent = reservations.fold<double>(
    0,
    (sum, r) => sum + r.totalPrice,
  );
  final totalSeats = reservations.fold<int>(
    0,
    (sum, r) => sum + r.seats,
  );
  final avgPrice = totalReservations > 0 
      ? totalSpent / totalReservations 
      : 0.0;
  
  return {
    'totalReservations': totalReservations,
    'totalSpent': totalSpent,
    'totalSeats': totalSeats,
    'avgPrice': avgPrice,
  };
}
```

## Example 10: Listen to Provider Changes

```dart
// Using Consumer for reactive updates
Widget watchReservationCount(BuildContext context) {
  return Consumer<ReservationProvider>(
    builder: (context, provider, child) {
      return Text(
        'Reservations: ${provider.reservationCount}',
        style: TextStyle(fontSize: 16),
      );
    },
  );
}

// Or using Selector for specific value changes
Widget watchHasReservations(BuildContext context) {
  return Selector<ReservationProvider, bool>(
    selector: (context, provider) => provider.hasReservations,
    builder: (context, hasReservations, child) {
      return Text(
        hasReservations ? 'You have reservations' : 'No reservations',
      );
    },
  );
}
```

## Integration in Existing Screens

### In ReservationHistoryScreen
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('My Reservations')),
    body: Consumer<ReservationProvider>(
      builder: (context, provider, _) {
        if (!provider.hasReservations) {
          return Center(child: Text('No reservations'));
        }
        return ListView.builder(
          itemCount: provider.reservationCount,
          itemBuilder: (context, index) {
            return _buildReservationCard(provider.reservations[index]);
          },
        );
      },
    ),
  );
}
```

### In HomeScreen Navbar
```dart
_buildNavItem(
  'Reservations',
  () => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const ReservationHistoryScreen(),
    ),
  ),
  false,
),
```

## Best Practices

### ✅ DO
- Use `Consumer` or `Selector` for reactive updates
- Call `initialize()` in app startup
- Always wrap in try-catch for database operations
- Use `debugPrint` for debugging
- Call `dispose()` when provider is no longer needed

### ❌ DON'T
- Don't hold direct references to provider outside of widget context
- Don't forget to handle loading states
- Don't make blocking database calls on main thread
- Don't forget proper error handling
- Don't rebuild entire lists unnecessarily

## Troubleshooting

### Data not persisting?
```dart
// Check if Hive is initialized
await Hive.initFlutter();
await ReservationProvider().initialize();
```

### UI not updating?
```dart
// Use Consumer or watch provider
// Make sure to call notifyListeners() after changes
```

### Empty list after restart?
```dart
// Ensure reservations are being saved
// Check Hive box is open and accessible
await provider.refresh(); // Reload from storage
```

