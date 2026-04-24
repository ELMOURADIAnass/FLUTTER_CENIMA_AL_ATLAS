import '../models/movie_local.dart';
import '../utils/local_movie_assets.dart';

// Curated list of local movies with proper naming and data
class LocalMovieDatabase {
  static final List<MovieLocal> movies = [
    MovieLocal(
      id: '1',
      title: 'Adam',
      imagePath: LocalMovieAssets.adam,
      sessionTime: '20:00',
      salle: 'Salle 1',
      price: 60.0,
      director: 'Maryam Touzani',
      genre: 'Drame',
      duration: '1h 38min',
    ),
    MovieLocal(
      id: '2',
      title: 'Les Chevaux de Dieu',
      imagePath: LocalMovieAssets.lesChevaux,
      sessionTime: '18:30',
      salle: 'Salle 2',
      price: 65.0,
      director: 'Nabil Ayouch',
      genre: 'Drame',
      duration: '1h 55min',
    ),
    MovieLocal(
      id: '3',
      title: 'Much Loved',
      imagePath: LocalMovieAssets.muchLoved,
      sessionTime: '19:00',
      salle: 'Salle 3',
      price: 55.0,
      director: 'Nabil Ayouch',
      genre: 'Drame',
      duration: '1h 44min',
    ),
    MovieLocal(
      id: '4',

      title: 'Casanegra',
      imagePath: LocalMovieAssets.casanegra,
      sessionTime: '17:00',
      salle: 'Salle 1',
      price: 55.0,
      director: 'Nour-Eddine Lakhmari',
      genre: 'Drame/Noir',
      duration: '2h 11min',
    ),
    MovieLocal(
      id: '5',
      title: 'La Source des Femmes',
      imagePath: LocalMovieAssets.laSourceDesFemmes,
      sessionTime: '15:30',
      salle: 'Salle 2',
      price: 60.0,
      director: 'Radu Mihaileanu',
      genre: 'Comédie/Drame',
      duration: '2h 14min',
    ),
    MovieLocal(
      id: '6',
      title: 'Le Miracle du Saint Inconnu',
      imagePath: LocalMovieAssets.leMiracleDuSaintInconnu,
      sessionTime: '21:00',
      salle: 'Salle 3',
      price: 50.0,
      director: 'Mohamed Abderrahman Tazi',
      genre: 'Comédie',
      duration: '1h 50min',
    ),
    MovieLocal(
      id: '7',
      title: 'Good Bye Morocco',
      imagePath: LocalMovieAssets.goodByeMorocco,
      sessionTime: '16:00',
      salle: 'Salle 1',
      price: 60.0,
      director: 'Ismaël Ferroukhi',
      genre: 'Drame/Thriller',
      duration: '2h 10min',
    ),
    MovieLocal(
      id: '8',
      title: 'Atlantique',
      imagePath: LocalMovieAssets.atlantique,
      sessionTime: '14:00',
      salle: 'Salle 2',
      price: 65.0,
      director: 'Mati Diop',
      genre: 'Drame/Fantastique',
      duration: '1h 44min',
    ),
    MovieLocal(
      id: '9',
      title: 'Rock the Casbah',
      imagePath: LocalMovieAssets.rockTheCasbah,
      sessionTime: '19:30',
      salle: 'Salle 3',
      price: 55.0,
      director: 'Laila Marrakchi',
      genre: 'Drame',
      duration: '1h 40min',
    ),
    MovieLocal(
      id: '10',
      title: 'Razzia',
      imagePath: LocalMovieAssets.razzia,
      sessionTime: '17:30',
      salle: 'Salle 1',
      price: 60.0,
      director: 'Derrick Borte',
      genre: 'Action/Thriller',
      duration: '1h 32min',
    ),
    MovieLocal(
      id: '11',
      title: 'A Thousand Times Stronger',
      imagePath: LocalMovieAssets.aThousandTimesStronger,
      sessionTime: '20:30',
      salle: 'Salle 2',
      price: 70.0,
      director: 'Abdelhamid Zaoui',
      genre: 'Drame',
      duration: '1h 52min',
    ),
  ];

  /// Get all movies
  static List<MovieLocal> getAllMovies() => movies;

  /// Get movie by ID
  static MovieLocal? getMovieById(String id) {
    try {
      return movies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get movies by salle
  static List<MovieLocal> getMoviesBySalle(String salle) {
    return movies.where((movie) => movie.salle == salle).toList();
  }

  /// Get movies by session time
  static List<MovieLocal> getMoviesByTime(String time) {
    return movies.where((movie) => movie.sessionTime == time).toList();
  }

  /// Get unique salle list
  static List<String> getUniqueSalles() {
    return movies.map((m) => m.salle).toSet().toList();
  }

  /// Get unique session times
  static List<String> getUniqueTimes() {
    return movies.map((m) => m.sessionTime).toSet().toList();
  }

  /// Get movies filtered by price range
  static List<MovieLocal> getMoviesByPriceRange(double minPrice, double maxPrice) {
    return movies
        .where((movie) => movie.price >= minPrice && movie.price <= maxPrice)
        .toList();
  }

  /// Get movies sorted by price
  static List<MovieLocal> getMoviesSortedByPrice({bool ascending = true}) {
    final sorted = [...movies];
    if (ascending) {
      sorted.sort((a, b) => a.price.compareTo(b.price));
    } else {
      sorted.sort((a, b) => b.price.compareTo(a.price));
    }
    return sorted;
  }

  /// Get movies sorted by session time
  static List<MovieLocal> getMoviesSortedByTime({bool ascending = true}) {
    final sorted = [...movies];
    if (ascending) {
      sorted.sort((a, b) => a.sessionTime.compareTo(b.sessionTime));
    } else {
      sorted.sort((a, b) => b.sessionTime.compareTo(a.sessionTime));
    }
    return sorted;
  }
}

