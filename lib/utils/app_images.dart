library;

/// Centralized image asset paths for the application
///
/// This class manages all image paths used throughout the app.
/// Benefits:
/// - Single source of truth for image locations
/// - Easy to update image paths
/// - Prevents typos and invalid paths
/// - Clear documentation of all assets

class AppImages {
  // Private constructor - prevent instantiation
  AppImages._();

  // Base paths
  static const String _baseImagePath = 'assets/images/posters';

  // Movie poster images (exact filenames as provided)
  // Images are stored in assets/images/posters/
  static const String adamPoster = '$_baseImagePath/Adam.jpg';
  static const String atlantiquePoster = '$_baseImagePath/Atlantique.jpeg';
  static const String casanegraPoster = '$_baseImagePath/casanegra.jpeg';
  static const String aThousandTimesStrongerPoster =
      '$_baseImagePath/A-Thousand-Times-Stronger.jpeg';
  static const String goodByeMoroccoPoster =
      '$_baseImagePath/Good-Bye_Morocco.png';
  static const String karimPoster = '$_baseImagePath/Karim.jpeg';
  static const String laSourceDesFemmesPoster =
      '$_baseImagePath/la-source-des-femmes.jpeg';
  static const String leMiracleDuSaintInconnuPoster =
      '$_baseImagePath/le-Miracle-du-Saint-Inconnu.jpeg';
  static const String leilaPoster = '$_baseImagePath/Leila.jpeg';
  static const String lesChevauDeDieuPoster =
      '$_baseImagePath/Les_Cheveux_de_Dieu.jpg';
  static const String muchLovedPoster = '$_baseImagePath/Much_oved.jpeg';
  static const String razziaPoster = '$_baseImagePath/razzia.jpeg';
  static const String rockTheCasbahPoster =
      '$_baseImagePath/rock-the-casbah.jpeg';
  static const String sophiaPoster = '$_baseImagePath/sofia.jpeg';
  static const String sophiePoster = '$_baseImagePath/Sophie.jpeg';

  // Placeholder/default images
  static const String placeholderMovie = '$_baseImagePath/placeholder.png';
  static const String heroBackground =
      'https://images.unsplash.com/photo-1598899134739-24c46f58b8c0?w=1200&h=600&fit=crop';

  /// Get image path by movie title
  /// Returns the image path for a given movie title
  /// If movie is not found, returns placeholder path
  static String getMovieImagePath(String movieTitle) {
    switch (movieTitle.toLowerCase()) {
      case 'adam':
        return adamPoster;
      case 'atlantique':
        return atlantiquePoster;
      case 'casanegra':
        return casanegraPoster;
      case 'a thousand times stronger':
        return aThousandTimesStrongerPoster;
      case 'good bye morocco':
      case 'good-bye_morocco':
        return goodByeMoroccoPoster;
      case 'karim':
        return karimPoster;
      case 'la source des femmes':
      case 'la-source-des-femmes':
        return laSourceDesFemmesPoster;
      case 'le miracle du saint inconnu':
      case 'le-miracle-du-saint-inconnu':
        return leMiracleDuSaintInconnuPoster;
      case 'leila':
        return leilaPoster;
      case 'les chevaux de dieu':
      case 'les_chevaux_de_dieu':
        return lesChevauDeDieuPoster;
      case 'much loved':
      case 'much_oved':
        return muchLovedPoster;
      case 'razzia':
        return razziaPoster;
      case 'rock the casbah':
      case 'rock-the-casbah':
        return rockTheCasbahPoster;
      case 'sofia':
        return sophiaPoster;
      case 'sophie':
        return sophiePoster;
      default:
        return placeholderMovie;
    }
  }

  /// Validate if image path exists
  /// Returns true if the path appears to be valid
  static bool isValidImagePath(String path) {
    if (path.isEmpty) return false;
    if (path.startsWith('http')) return true; // Network images
    if (path.startsWith('assets/')) return true; // Local assets
    return false;
  }
}

