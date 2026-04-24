// Centralized local movie image assets
class LocalMovieAssets {
  // Base path for local movie images
  static const String _basePath = 'assets/images/posters/';

  // Movie image paths (organized for easy maintenance)
  static const String aThousandTimesStronger = '${_basePath}A-Thousand-Times-Stronger.jpeg';
  static const String adam = '${_basePath}Adam.jpg';
  static const String atlantique = '${_basePath}Atlantique.jpeg';
  static const String casanegra = '${_basePath}casanegra.jpeg';
  static const String goodByeMorocco = '${_basePath}Good-Bye_Morocco.png';
  static const String karim = '${_basePath}Karim.jpeg';
  static const String laSourceDesFemmes = '${_basePath}la-source-des-femmes.jpeg';
  static const String leMiracleDuSaintInconnu = '${_basePath}le-Miracle-du-Saint-Inconnu.jpeg';
  static const String leila = '${_basePath}Leila.jpeg';
  static const String lesChevaux = '${_basePath}Les_Cheveux_de_Dieu.jpg';
  static const String logo = '${_basePath}logo4.png';
  static const String muchLoved = '${_basePath}Much_oved.jpeg';
  static const String razzia = '${_basePath}razzia.jpeg';
  static const String rockTheCasbah = '${_basePath}rock-the-casbah.jpeg';
  static const String sofia = '${_basePath}sofia.jpeg';
  static const String sophie = '${_basePath}Sophie.jpeg';

  // Fallback/placeholder image
  static const String placeholder = '${_basePath}logo4.png';

  /// Get all available movie assets as a map
  static const Map<String, String> allMovieAssets = {
    'a-thousand-times-stronger': aThousandTimesStronger,
    'adam': adam,
    'atlantique': atlantique,
    'casanegra': casanegra,
    'good-bye-morocco': goodByeMorocco,
    'karim': karim,
    'la-source-des-femmes': laSourceDesFemmes,
    'le-miracle-du-saint-inconnu': leMiracleDuSaintInconnu,
    'leila': leila,
    'les-chevaux': lesChevaux,
    'much-loved': muchLoved,
    'razzia': razzia,
    'rock-the-casbah': rockTheCasbah,
    'sofia': sofia,
    'sophie': sophie,
  };

  /// Get image path by key, with fallback
  static String getImagePath(String key, {String fallback = placeholder}) {
    return allMovieAssets[key.toLowerCase()] ?? fallback;
  }

  /// Validate if image path exists in assets
  static bool isValidImagePath(String path) {
    return allMovieAssets.containsValue(path);
  }
}

