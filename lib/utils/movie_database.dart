import '../models/movie.dart';
import 'app_images.dart';

/// Centralized movie database with proper image mappings
///
/// This class provides a curated list of Moroccan and international films
/// with complete metadata and locally-stored images.

class MovieDatabase {
  MovieDatabase._();

  /// Complete list of all movies in the cinema
  static final List<Movie> allMovies = [
    // 1. Adam - Moroccan Drama
    Movie(
      id: '1',
      title: 'Adam',
      originalTitle: 'Adam',
      director: 'Maryam Touzani',
      year: 2019,
      duration: '1h 38min',
      rating: 7.4,
      genre: 'Drama',
      synopsis:
          'A woman and man alone, confined in a Casablanca flat, hold each other hostage.',
      posterUrl: AppImages.adamPoster,
      price: 60.0,
      category: MovieCategory.moroccan,
      language: 'FR',
      showtimes: ['14:00', '17:00', '20:00'],
    ),

    // 2. Les Chevaux de Dieu - Moroccan Thriller
    Movie(
      id: '2',
      title: 'Les Chevaux de Dieu',
      originalTitle: 'Les Chevaux de Dieu',
      director: 'Nabil Ayouch',
      year: 2012,
      duration: '1h 55min',
      rating: 7.3,
      genre: 'Drama/Thriller',
      synopsis:
          'Young men in Marrakech spend their days searching for ways to escape poverty.',
      posterUrl: AppImages.lesChevauDeDieuPoster,
      price: 65.0,
      category: MovieCategory.moroccan,
      language: 'FR',
      showtimes: ['15:00', '18:30', '21:00'],
    ),

    // 3. Much Loved - Moroccan Drama
    Movie(
      id: '3',
      title: 'Much Loved',
      originalTitle: 'Beaucoup trop',
      director: 'Nabil Ayouch',
      year: 2015,
      duration: '1h 44min',
      rating: 6.9,
      genre: 'Drama',
      synopsis:
          'Four women in present-day Morocco navigate a world of taboos and secrets.',
      posterUrl: AppImages.muchLovedPoster,
      price: 55.0,
      category: MovieCategory.moroccan,
      language: 'FR',
      showtimes: ['16:00', '19:00', '21:30'],
    ),

    // 4. Casanegra - Moroccan Neo-Noir
    Movie(
      id: '4',
      title: 'Casanegra',
      originalTitle: 'Casanegra',
      director: 'Nour-Eddine Lakhmari',
      year: 2008,
      duration: '2h 11min',
      rating: 6.8,
      genre: 'Drama/Noir',
      synopsis:
          'A neo-noir tale set in the dark corners of Casablanca\'s criminal underworld.',
      posterUrl: AppImages.casanegraPoster,
      price: 55.0,
      category: MovieCategory.moroccan,
      language: 'FR',
      showtimes: ['14:30', '17:00', '20:00'],
    ),

    // 5. La Source des Femmes - Franco-Moroccan Comedy-Drama
    Movie(
      id: '5',
      title: 'La Source des Femmes',
      originalTitle: 'La Source des Femmes',
      director: 'Radu Mihaileanu',
      year: 2011,
      duration: '2h 14min',
      rating: 7.2,
      genre: 'Comedy/Drama',
      synopsis:
          'In a remote village, women stop having sexual relations to force men to help fetch water.',
      posterUrl: AppImages.laSourceDesFemmesPoster,
      price: 60.0,
      category: MovieCategory.moroccan,
      language: 'FR',
      showtimes: ['15:30', '18:00', '20:30'],
    ),

    // 6. Le Miracle du Saint Inconnu - Moroccan Comedy
    Movie(
      id: '6',
      title: 'Le Miracle du Saint Inconnu',
      originalTitle: 'Le Miracle du Saint Inconnu',
      director: 'Mohamed Abderrahman Tazi',
      year: 1994,
      duration: '1h 50min',
      rating: 7.0,
      genre: 'Comedy',
      synopsis: 'A humorous tale of miracles and faith in a small Moroccan town.',
      posterUrl: AppImages.leMiracleDuSaintInconnuPoster,
      price: 50.0,
      category: MovieCategory.moroccan,
      language: 'FR',
      showtimes: ['14:00', '16:30', '21:00'],
    ),

    // 7. Good Bye Morocco - International Thriller
    Movie(
      id: '7',
      title: 'Good Bye Morocco',
      originalTitle: 'Good Bye Morocco',
      director: 'Ismaël Ferroukhi',
      year: 2012,
      duration: '2h 10min',
      rating: 7.1,
      genre: 'Drama/Thriller',
      synopsis:
          'A psychological thriller exploring themes of identity and belonging.',
      posterUrl: AppImages.goodByeMoroccoPoster,
      price: 60.0,
      category: MovieCategory.moroccan,
      language: 'FR',
      showtimes: ['16:00', '19:00', '21:30'],
    ),

    // 8. Atlantique - Franco-Senegalese Fantasy
    Movie(
      id: '8',
      title: 'Atlantique',
      originalTitle: 'Atlantique',
      director: 'Mati Diop',
      year: 2019,
      duration: '1h 44min',
      rating: 6.7,
      genre: 'Drama/Fantasy',
      synopsis:
          'A supernatural love story set against the backdrop of West African migration.',
      posterUrl: AppImages.atlantiquePoster,
      price: 65.0,
      category: MovieCategory.international,
      language: 'FR',
      showtimes: ['14:00', '17:30', '20:00'],
    ),

    // 9. Rock the Casbah - Moroccan Drama
    Movie(
      id: '9',
      title: 'Rock the Casbah',
      originalTitle: 'Rock the Casbah',
      director: 'Laila Marrakchi',
      year: 2013,
      duration: '1h 40min',
      rating: 6.5,
      genre: 'Drama',
      synopsis: 'A story of youth and rebellion in contemporary Casablanca.',
      posterUrl: AppImages.rockTheCasbahPoster,
      price: 55.0,
      category: MovieCategory.moroccan,
      language: 'FR',
      showtimes: ['15:00', '17:30', '19:30'],
    ),

    // 10. Razzia - Franco-American Action
    Movie(
      id: '10',
      title: 'Razzia',
      originalTitle: 'Razzia',
      director: 'Derrick Borte',
      year: 2023,
      duration: '1h 32min',
      rating: 6.2,
      genre: 'Action/Thriller',
      synopsis: 'A high-octane action thriller with international intrigue.',
      posterUrl: AppImages.razziaPoster,
      price: 60.0,
      category: MovieCategory.international,
      language: 'FR',
      showtimes: ['17:00', '19:00', '21:00'],
    ),

    // 11. A Thousand Times Stronger - Moroccan Drama
    Movie(
      id: '11',
      title: 'A Thousand Times Stronger',
      originalTitle: 'A Thousand Times Stronger',
      director: 'Abdelhamid Zaoui',
      year: 2013,
      duration: '1h 52min',
      rating: 7.0,
      genre: 'Drama',
      synopsis:
          'An inspiring story of resilience and human spirit in challenging circumstances.',
      posterUrl: AppImages.aThousandTimesStrongerPoster,
      price: 70.0,
      category: MovieCategory.moroccan,
      language: 'FR',
      showtimes: ['14:30', '17:00', '20:30'],
    ),

    // 12. Karim - Moroccan Character Study
    Movie(
      id: '12',
      title: 'Karim',
      originalTitle: 'Karim',
      director: 'various',
      year: 2014,
      duration: '1h 45min',
      rating: 6.8,
      genre: 'Drama',
      synopsis: 'A character study exploring life in the streets of Marrakech.',
      posterUrl: AppImages.karimPoster,
      price: 55.0,
      category: MovieCategory.moroccan,
      language: 'FR',
      showtimes: ['15:30', '18:00', '20:00'],
    ),

    // 13. Leila - Moroccan Drama
    Movie(
      id: '13',
      title: 'Leila',
      originalTitle: 'Leila',
      director: 'various',
      year: 2015,
      duration: '1h 50min',
      rating: 7.1,
      genre: 'Drama',
      synopsis: 'A powerful story centered around a female protagonist in Morocco.',
      posterUrl: AppImages.leilaPoster,
      price: 60.0,
      category: MovieCategory.moroccan,
      language: 'FR',
      showtimes: ['16:00', '18:30', '21:00'],
    ),

    // 14. Sofia - International Drama
    Movie(
      id: '14',
      title: 'Sofia',
      originalTitle: 'Sofia',
      director: 'various',
      year: 2016,
      duration: '1h 55min',
      rating: 6.9,
      genre: 'Drama',
      synopsis: 'An international co-production with rich cultural narratives.',
      posterUrl: AppImages.sophiaPoster,
      price: 65.0,
      category: MovieCategory.international,
      language: 'FR',
      showtimes: ['15:00', '17:30', '19:30'],
    ),

    // 15. Sophie - International Comedy-Drama
    Movie(
      id: '15',
      title: 'Sophie',
      originalTitle: 'Sophie',
      director: 'various',
      year: 2017,
      duration: '1h 48min',
      rating: 7.0,
      genre: 'Comedy/Drama',
      synopsis: 'A lighthearted yet touching story about modern relationships.',
      posterUrl: AppImages.sophiePoster,
      price: 60.0,
      category: MovieCategory.international,
      language: 'FR',
      showtimes: ['14:30', '16:30', '19:00'],
    ),
  ];

  /// Get all movies
  static List<Movie> getAllMovies() => allMovies;

  /// Get featured movies (first 5)
  static List<Movie> getFeaturedMovies() => allMovies.take(5).toList();

  /// Get movies by category
  static List<Movie> getMoviesByCategory(MovieCategory category) {
    if (category == MovieCategory.all) return allMovies;
    return allMovies.where((movie) => movie.category == category).toList();
  }

  /// Get movie by ID
  static Movie? getMovieById(String id) {
    try {
      return allMovies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get movies by price range
  static List<Movie> getMoviesByPriceRange(double minPrice, double maxPrice) {
    return allMovies
        .where((movie) =>
            movie.price >= minPrice && movie.price <= maxPrice)
        .toList();
  }

  /// Search movies by title
  static List<Movie> searchMovies(String query) {
    final lowerQuery = query.toLowerCase();
    return allMovies
        .where((movie) =>
            movie.title.toLowerCase().contains(lowerQuery) ||
            movie.director.toLowerCase().contains(lowerQuery) ||
            movie.genre.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Get unique genres
  static List<String> getUniqueGenres() {
    final genres = <String>{};
    for (final movie in allMovies) {
      genres.add(movie.genre);
    }
    return genres.toList()..sort();
  }

  /// Get unique languages
  static List<String> getUniqueLanguages() {
    final languages = <String>{};
    for (final movie in allMovies) {
      languages.add(movie.language);
    }
    return languages.toList()..sort();
  }

  /// Get all unique showtimes
  static List<String> getAllShowtimes() {
    final times = <String>{};
    for (final movie in allMovies) {
      times.addAll(movie.showtimes);
    }
    final timeList = times.toList();
    timeList.sort();
    return timeList;
  }

  /// Get movies sorted by rating (highest first)
  static List<Movie> getMoviesSortedByRating({bool descending = true}) {
    final sorted = [...allMovies];
    if (descending) {
      sorted.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      sorted.sort((a, b) => a.rating.compareTo(b.rating));
    }
    return sorted;
  }

  /// Get movies sorted by price
  static List<Movie> getMoviesSortedByPrice({bool ascending = true}) {
    final sorted = [...allMovies];
    if (ascending) {
      sorted.sort((a, b) => a.price.compareTo(b.price));
    } else {
      sorted.sort((a, b) => b.price.compareTo(a.price));
    }
    return sorted;
  }
}

