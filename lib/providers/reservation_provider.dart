import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/reservation.dart';

// Provider for managing reservations with persistent storage
class ReservationProvider extends ChangeNotifier {
  static const String reservationsBoxName = 'reservations';

  late Box<dynamic> _reservationsBox;
  List<Reservation> _reservations = [];

  List<Reservation> get reservations => List.unmodifiable(
    _reservations..sort((a, b) => b.createdAt.compareTo(a.createdAt))
  );

  bool get hasReservations => _reservations.isNotEmpty;

  int get reservationCount => _reservations.length;

  // Initialize and load reservations from Hive
  Future<void> initialize() async {
    try {
      _reservationsBox = await Hive.openBox(reservationsBoxName);
      _loadReservations();
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing ReservationProvider: $e');
    }
  }

  // Load reservations from Hive storage
  void _loadReservations() {
    _reservations = [];
    final maps = _reservationsBox.values.toList();
    for (final map in maps) {
      try {
        final reservation = Reservation.fromMap(
          Map<String, dynamic>.from(map as Map),
        );
        _reservations.add(reservation);
      } catch (e) {
        debugPrint('Error loading reservation: $e');
      }
    }
    // Sort by date descending (latest first)
    _reservations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Add a new reservation
  Future<void> addReservation(Reservation reservation) async {
    try {
      await _reservationsBox.put(reservation.id, reservation.toMap());
      _reservations.add(reservation);
      _reservations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding reservation: $e');
      rethrow;
    }
  }

  // Delete a reservation
  Future<void> deleteReservation(String reservationId) async {
    try {
      await _reservationsBox.delete(reservationId);
      _reservations.removeWhere((r) => r.id == reservationId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting reservation: $e');
      rethrow;
    }
  }

  // Get reservation by ID
  Reservation? getReservationById(String id) {
    try {
      return _reservations.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear all reservations
  Future<void> clearAllReservations() async {
    try {
      await _reservationsBox.clear();
      _reservations.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing reservations: $e');
      rethrow;
    }
  }

  // Refresh reservations from storage
  Future<void> refresh() async {
    _loadReservations();
    notifyListeners();
  }

  @override
  void dispose() {
    _reservationsBox.close();
    super.dispose();
  }
}

