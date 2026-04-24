// Movie model representing a film in the cinema catalog
class Movie {
  final String id;
  final String title;
  final String originalTitle;
  final String director;
  final int year;
  final String duration;
  final double rating;
  final String genre;
  final String synopsis;
  final String posterUrl;
  final double price;
  final MovieCategory category;
  final String language;
  final List<String> showtimes;

  const Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.director,
    required this.year,
    required this.duration,
    required this.rating,
    required this.genre,
    required this.synopsis,
    required this.posterUrl,
    required this.price,
    required this.category,
    required this.language,
    required this.showtimes,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? originalTitle,
    String? director,
    int? year,
    String? duration,
    double? rating,
    String? genre,
    String? synopsis,
    String? posterUrl,
    double? price,
    MovieCategory? category,
    String? language,
    List<String>? showtimes,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      originalTitle: originalTitle ?? this.originalTitle,
      director: director ?? this.director,
      year: year ?? this.year,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      genre: genre ?? this.genre,
      synopsis: synopsis ?? this.synopsis,
      posterUrl: posterUrl ?? this.posterUrl,
      price: price ?? this.price,
      category: category ?? this.category,
      language: language ?? this.language,
      showtimes: showtimes ?? this.showtimes,
    );
  }
}

// Categories for filtering movies
enum MovieCategory {
  all('all'),
  moroccan('moroccan'),
  international('international'),
  classics('classics'),
  newReleases('newReleases');

  final String value;
  const MovieCategory(this.value);

  String getLabel(String language) {
    switch (this) {
      case MovieCategory.all:
        return _getLocalized('Tous', 'All', 'الكل', language);
      case MovieCategory.moroccan:
        return _getLocalized('Marocains', 'Moroccan', 'مغربية', language);
      case MovieCategory.international:
        return _getLocalized('Internationaux', 'International', 'عالمية', language);
      case MovieCategory.classics:
        return _getLocalized('Classiques', 'Classics', 'كلاسيكية', language);
      case MovieCategory.newReleases:
        return _getLocalized('Nouveautes', 'New Releases', 'جديدة', language);
    }
  }

  String _getLocalized(String fr, String en, String ar, String lang) {
    switch (lang) {
      case 'ar':
        return ar;
      case 'en':
        return en;
      default:
        return fr;
    }
  }
}

// Screening/Showtime model
class Screening {
  final String id;
  final Movie movie;
  final DateTime date;
  final String time;
  final String hall;
  final String language;
  final double price;
  final int availableSeats;

  const Screening({
    required this.id,
    required this.movie,
    required this.date,
    required this.time,
    required this.hall,
    required this.language,
    required this.price,
    required this.availableSeats,
  });
}

// Booking model with room support
class Booking {
  final String id;
  final Screening screening;
  final String roomId;
  final String roomName;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final int seatCount;
  final double totalPrice;
  final DateTime bookingDate;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.screening,
    required this.roomId,
    required this.roomName,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.seatCount,
    required this.totalPrice,
    required this.bookingDate,
    this.status = BookingStatus.confirmed,
  });

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

enum BookingStatus { pending, confirmed, cancelled }

// Testimonial model
class Testimonial {
  final String id;
  final String name;
  final String avatarUrl;
  final String text;
  final double rating;
  final DateTime? date;

  const Testimonial({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.text,
    required this.rating,
    required this.date,
  });
}
