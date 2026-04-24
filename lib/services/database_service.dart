import 'package:hive_flutter/hive_flutter.dart';
import '../models/room.dart';

// Hive database service for local storage - uses manual serialization
class DatabaseService {
  static const String roomsBoxName = 'rooms';
  static const String bookingsBoxName = 'bookings';

  static Box<dynamic>? _roomsBox;
  static Box<dynamic>? _bookingsBox;

  // Initialize Hive
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Open boxes
    _roomsBox = await Hive.openBox(roomsBoxName);
    _bookingsBox = await Hive.openBox(bookingsBoxName);

    // Seed default rooms if empty
    if (_roomsBox!.isEmpty) {
      await seedDefaultRooms();
    }
  }

  // Seed default rooms
  static Future<void> seedDefaultRooms() async {
    for (final room in defaultRooms) {
      await _roomsBox?.put(room.id, room.toMap());
    }
  }

  // Get all rooms
  static List<Room> getAllRooms() {
    final maps = _roomsBox?.values.toList() ?? [];
    return maps.map((m) => Room.fromMap(Map<String, dynamic>.from(m as Map))).toList();
  }

  // Get room by ID
  static Room? getRoomById(String id) {
    final map = _roomsBox?.get(id);
    if (map == null) return null;
    return Room.fromMap(Map<String, dynamic>.from(map as Map));
  }

  // Add or update room
  static Future<void> saveRoom(Room room) async {
    await _roomsBox?.put(room.id, room.toMap());
  }

  // Delete room
  static Future<void> deleteRoom(String id) async {
    await _roomsBox?.delete(id);
  }

  // Get available seats for a room at specific time
  static int getAvailableSeats(String roomId, String movieId, DateTime date, String time) {
    final room = getRoomById(roomId);
    if (room == null) return 0;

    final screeningKey = '${movieId}_${roomId}_${date.toIso8601String()}_$time';
    final bookedSeats = _bookingsBox?.get(screeningKey) as int? ?? 0;

    return room.capacity - bookedSeats;
  }

  // Book seats for a screening
  static Future<bool> bookSeats(
    String roomId,
    String movieId,
    DateTime date,
    String time,
    int seats,
  ) async {
    final available = getAvailableSeats(roomId, movieId, date, time);
    if (seats > available) return false;

    final screeningKey = '${movieId}_${roomId}_${date.toIso8601String()}_$time';
    final currentBooked = _bookingsBox?.get(screeningKey) as int? ?? 0;
    await _bookingsBox?.put(screeningKey, currentBooked + seats);

    return true;
  }

  // Close all boxes
  static Future<void> close() async {
    await _roomsBox?.close();
    await _bookingsBox?.close();
  }
}
