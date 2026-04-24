// Local movie model for asset-based movies
class MovieLocal {
  final String id;
  final String title;
  final String imagePath;
  final String sessionTime;
  final String salle;
  final double price;
  final String? director;
  final String? genre;
  final String? duration;

  const MovieLocal({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.sessionTime,
    required this.salle,
    required this.price,
    this.director,
    this.genre,
    this.duration,
  });

  // CopyWith method for immutability
  MovieLocal copyWith({
    String? id,
    String? title,
    String? imagePath,
    String? sessionTime,
    String? salle,
    double? price,
    String? director,
    String? genre,
    String? duration,
  }) {
    return MovieLocal(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      sessionTime: sessionTime ?? this.sessionTime,
      salle: salle ?? this.salle,
      price: price ?? this.price,
      director: director ?? this.director,
      genre: genre ?? this.genre,
      duration: duration ?? this.duration,
    );
  }

  @override
  String toString() {
    return 'MovieLocal(id: $id, title: $title, sessionTime: $sessionTime, salle: $salle, price: $price)';
  }
}

