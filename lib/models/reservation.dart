// Reservation model for storing user bookings
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

  const Reservation({
    required this.id,
    required this.filmName,
    required this.sessionTime,
    required this.salle,
    required this.seats,
    required this.totalPrice,
    required this.createdAt,
    required this.language,
    required this.moviePosterUrl,
  });

  // Convert Reservation to Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filmName': filmName,
      'sessionTime': sessionTime,
      'salle': salle,
      'seats': seats,
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'language': language,
      'moviePosterUrl': moviePosterUrl,
    };
  }

  // Create Reservation from Map
  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] as String,
      filmName: map['filmName'] as String,
      sessionTime: map['sessionTime'] as String,
      salle: map['salle'] as String,
      seats: map['seats'] as int,
      totalPrice: map['totalPrice'] as double,
      createdAt: DateTime.parse(map['createdAt'] as String),
      language: map['language'] as String,
      moviePosterUrl: map['moviePosterUrl'] as String,
    );
  }

  // CopyWith method for immutability
  Reservation copyWith({
    String? id,
    String? filmName,
    String? sessionTime,
    String? salle,
    int? seats,
    double? totalPrice,
    DateTime? createdAt,
    String? language,
    String? moviePosterUrl,
  }) {
    return Reservation(
      id: id ?? this.id,
      filmName: filmName ?? this.filmName,
      sessionTime: sessionTime ?? this.sessionTime,
      salle: salle ?? this.salle,
      seats: seats ?? this.seats,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
      language: language ?? this.language,
      moviePosterUrl: moviePosterUrl ?? this.moviePosterUrl,
    );
  }
}

