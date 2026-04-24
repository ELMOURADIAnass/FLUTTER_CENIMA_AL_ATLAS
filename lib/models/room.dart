// Room model with manual serialization for Hive
class Room {
  final String id;
  final String name;
  final int capacity;
  final String? description;

  const Room({
    required this.id,
    required this.name,
    required this.capacity,
    this.description,
  });

  // Convert Room to Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'description': description,
    };
  }

  // Create Room from Map
  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String,
      name: map['name'] as String,
      capacity: map['capacity'] as int,
      description: map['description'] as String?,
    );
  }

  Room copyWith({
    String? id,
    String? name,
    int? capacity,
    String? description,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      description: description ?? this.description,
    );
  }

  @override
  String toString() => 'Room(id: $id, name: $name, capacity: $capacity)';
}

// Room data for initial seeding
final List<Room> defaultRooms = [
  Room(id: 'room_1', name: 'Salle Atlas', capacity: 120, description: 'Grande salle principale'),
  Room(id: 'room_2', name: 'Salle Marrakech', capacity: 80, description: 'Salle moyenne'),
  Room(id: 'room_3', name: 'Salle Casablanca', capacity: 60, description: 'Salle intime'),
  Room(id: 'room_4', name: 'Salle Premium', capacity: 40, description: 'Experience VIP'),
];
