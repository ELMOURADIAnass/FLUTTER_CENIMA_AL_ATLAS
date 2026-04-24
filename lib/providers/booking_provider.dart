import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/room.dart';
import '../services/database_service.dart';

// Provider for managing bookings with room support
class BookingProvider extends ChangeNotifier {
  final List<Booking> _bookings = [];
  List<Room> _rooms = [];

  List<Booking> get bookings => List.unmodifiable(_bookings);
  List<Room> get rooms => List.unmodifiable(_rooms);

  // Initialize and load rooms from database
  Future<void> initialize() async {
    _rooms = DatabaseService.getAllRooms();
    notifyListeners();
  }

  // Get room by ID
  Room? getRoomById(String id) {
    try {
      return _rooms.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get available rooms for a movie at specific time
  List<Room> getAvailableRooms(String movieId, DateTime date, String time) {
    return _rooms.where((room) {
      final availableSeats = DatabaseService.getAvailableSeats(
        room.id,
        movieId,
        date,
        time,
      );
      return availableSeats > 0;
    }).toList();
  }

  // Get available seats for a specific room and time
  int getAvailableSeats(String roomId, String movieId, DateTime date, String time) {
    return DatabaseService.getAvailableSeats(roomId, movieId, date, time);
  }

  // Validate if booking is possible
  bool canBook(String roomId, String movieId, DateTime date, String time, int seats) {
    final availableSeats = getAvailableSeats(roomId, movieId, date, time);
    return seats <= availableSeats;
  }

  // Add booking with room validation
  Future<bool> addBooking(Booking booking) async {
    final canProceed = canBook(
      booking.roomId,
      booking.screening.movie.id,
      booking.screening.date,
      booking.screening.time,
      booking.seatCount,
    );

    if (!canProceed) return false;

    // Save to database
    final success = await DatabaseService.bookSeats(
      booking.roomId,
      booking.screening.movie.id,
      booking.screening.date,
      booking.screening.time,
      booking.seatCount,
    );

    if (success) {
      _bookings.add(booking);
      notifyListeners();
    }

    return success;
  }

  void cancelBooking(String bookingId) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(
        status: BookingStatus.cancelled,
      );
      notifyListeners();
    }
  }

  List<Booking> get activeBookings =>
      _bookings.where((b) => b.status == BookingStatus.confirmed).toList();

  double get totalRevenue => activeBookings.fold(
        0,
        (sum, booking) => sum + booking.totalPrice,
      );
}

// Extension for Booking copyWith
extension BookingCopyWith on Booking {
  Booking copyWith({
    String? id,
    Screening? screening,
    String? roomId,
    String? roomName,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    int? seatCount,
    double? totalPrice,
    DateTime? bookingDate,
    BookingStatus? status,
  }) {
    return Booking(
      id: id ?? this.id,
      screening: screening ?? this.screening,
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      seatCount: seatCount ?? this.seatCount,
      totalPrice: totalPrice ?? this.totalPrice,
      bookingDate: bookingDate ?? this.bookingDate,
      status: status ?? this.status,
    );
  }
}
