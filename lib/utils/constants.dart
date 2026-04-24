// App-wide constants for Cinema Atlas
import 'app_images.dart';

class AppConstants {
  // App info
  static const String appName = 'Cinéma Al-ATLAS';
  static const String tagline = 'Une expérience cinématographique authentique marroquaine';

  // Contact info
  static const String address = '15 Avenue Mohammed V, Quartier Gueliz, Marrakech, Maroc';
  static const String phone = '+212 5XX-XXXXXX';
  static const String email = 'contact@cinemaatlas.ma';
  static const String hours = 'Tous les jours : 14h00 - 23h00';
  static const String allDays = 'Tous les jours : 14h00 - 23h00';

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 500);

  // Spacing
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  static const double cardRadius = 12.0;
  static const double buttonRadius = 8.0;

  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
}


class ImageConstants {
  static const String placeholderPoster = 'https://via.placeholder.com/300x450/1a1a2e/ffffff?text=Cinema+Atlas';
  static const String heroBackground = 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=1920';
  static const String avatar1 = 'https://i.pravatar.cc/150?img=1';
  static const String avatar2 = 'https://i.pravatar.cc/150?img=8';
  static const String avatar3 = 'https://i.pravatar.cc/150?img=5';

  // Movie posters - LOCAL ASSETS (stored in assets/images/)
  // These will display when the app runs
  static const String adam = AppImages.adamPoster;
  static const String chevauxDieu = AppImages.lesChevauDeDieuPoster;
  static const String muchLoved = AppImages.muchLovedPoster;
  static const String goodbyeMorocco = AppImages.goodByeMoroccoPoster;
  static const String atlantique = AppImages.atlantiquePoster;
  static const String casanegra = AppImages.casanegraPoster;
  static const String karim = AppImages.karimPoster;
  static const String leila = AppImages.leilaPoster;
  static const String laSourceDesFemmes = AppImages.laSourceDesFemmesPoster;
  static const String leMiracle = AppImages.leMiracleDuSaintInconnuPoster;
  static const String razzia = AppImages.razziaPoster;
  static const String rockTheCasbah = AppImages.rockTheCasbahPoster;
  static const String aThousandTimes = AppImages.aThousandTimesStrongerPoster;
  static const String sofia = AppImages.sophiaPoster;
  static const String sophie = AppImages.sophiePoster;
}
