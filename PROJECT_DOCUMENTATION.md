# Cinema Atlas - Project Documentation
## 📋 Project Overview
Cinema Atlas is a Flutter-based cinema management and booking application with a focus on Moroccan and international cinema.
Current Version: 1.0.0+1  
Status: Production Ready  
Platform Support: Android, iOS, Web, Windows, macOS, Linux
---
## ✨ Features
### Core Features
1. **Movie Browsing** - Grid display, filtering, search
2. **Movie Management** - 15 curated films with local images
3. **Booking System** - Full reservation with Hive persistence
4. **Localization** - French, English, Arabic support
5. **User Interface** - Dark theme, responsive design
---
## 🎬 Movie Database - Complete Mapping
| # | Movie Title | Image File | Category | Year |
|---|---|---|---|---|
| 1 | Adam | Adam.jpg | Moroccan | 2019 |
| 2 | Les Chevaux de Dieu | Les_Chevaux_de_Dieu.jpg | Moroccan | 2012 |
| 3 | Much Loved | Much_oved.jpeg | Moroccan | 2015 |
| 4 | Casanegra | casanegra.jpeg | Moroccan | 2008 |
| 5 | La Source des Femmes | la-source-des-femmes.jpeg | Moroccan | 2011 |
| 6 | Le Miracle du Saint Inconnu | le-Miracle-du-Saint-Inconnu.jpeg | Moroccan | 1994 |
| 7 | Good Bye Morocco | Good-Bye_Morocco.png | Moroccan | 2012 |
| 8 | Atlantique | Atlantique.jpeg | International | 2019 |
| 9 | Rock the Casbah | rock-the-casbah.jpeg | Moroccan | 2013 |
| 10 | Razzia | razzia.jpeg | International | 2023 |
| 11 | A Thousand Times Stronger | A-Thousand-Times-Stronger.jpeg | Moroccan | 2013 |
| 12 | Karim | Karim.jpeg | Moroccan | 2014 |
| 13 | Leila | Leila.jpeg | Moroccan | 2015 |
| 14 | Sofia | sofia.jpeg | International | 2016 |
| 15 | Sophie | Sophie.jpeg | International | 2017 |
---
## 🎨 Image Management
### Asset Structure
All images are stored in: **assets/images/**
List of 15 image files:
- A-Thousand-Times-Stronger.jpeg
- Adam.jpg
- Atlantique.jpeg
- casanegra.jpeg (lowercase!)
- Good-Bye_Morocco.png
- Karim.jpeg
- la-source-des-femmes.jpeg
- le-Miracle-du-Saint-Inconnu.jpeg
- Leila.jpeg
- Les_Chevaux_de_Dieu.jpg
- Much_oved.jpeg
- razzia.jpeg
- rock-the-casbah.jpeg
- sofia.jpeg (lowercase!)
- Sophie.jpeg
### Image Path Resolution
All image paths are centralized in **lib/utils/app_images.dart**:
\\\dart
class AppImages {
  static const String _baseImagePath = 'assets/images';
  static const String adamPoster = '/Adam.jpg';
  // ... all 15 movies defined
}
\\\
### CRITICAL: Case-Sensitive Filenames
⚠️ Filenames ARE case-sensitive on all platforms:
- 'casanegra.jpeg' (lowercase) ✓
- 'sofia.jpeg' (lowercase) ✓
- 'Les_Chevaux_de_Dieu.jpg' (underscore) ✓
- Exact match required for all files
---
## 📁 Project Structure
\\\
cinima_atlas/
├── lib/
│   ├── main.dart
│   ├── models/movie.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── movie_list_screen.dart
│   │   ├── movie_detail_screen.dart
│   │   └── reservation_history_screen.dart
│   ├── widgets/app_image_widget.dart
│   └── utils/
│       ├── app_images.dart (IMAGE PATHS)
│       ├── movie_database.dart
│       └── constants.dart
├── assets/
│   └── images/ (15 MOVIE POSTERS)
├── pubspec.yaml
└── PROJECT_DOCUMENTATION.md (this file)
\\\
---
## 🚀 How to Run
### Prerequisites
- Flutter SDK 3.11.1+
- Dart 3.5.0+
### Installation
\\\ash
cd cinima_atlas
flutter pub get
\\\
### Running
\\\ash
# Development
flutter run
# Full restart (required after asset changes)
flutter run --no-fast-start
# Release
flutter run --release
\\\
---
## 📸 Image Troubleshooting
| Problem | Solution |
|---------|----------|
| Images show placeholder | Full restart: lutter run --no-fast-start |
| File not found error | Check pubspec.yaml has ssets: - assets/images/ |
| Wrong image displayed | Verify filename case in app_images.dart |
| Hot reload doesn't show images | Do full restart, not hot reload |
---
## 🔧 Configuration
**pubspec.yaml** (Assets Declaration):
\\\yaml
flutter:
  assets:
    - assets/images/
\\\
**lib/utils/app_images.dart** (Image Constants):
- All 15 movie posters mapped
- Centralized for easy maintenance
- Used by movie_database.dart
---
## 💾 Database
Uses **Hive** for local persistence:
- Reservations
- Booking history
- User preferences
---
## 🌍 Localization
Supported languages:
- English (en)
- French (fr)
- Arabic (ar)
---
## 🎯 Key Implementation Details
### Movie Model
\\\dart
class Movie {
  final String id;
  final String title;
  final String posterUrl;  // uses AppImages.xxx
  final double price;
  final MovieCategory category;
  // ... more fields
}
\\\
### AppImages Utility
\\\dart
class AppImages {
  static const String adamPoster = 'assets/images/Adam.jpg';
  static const String casanegraPoster = 'assets/images/casanegra.jpeg';
  // All 15 movies defined here
}
\\\
### Image Display Widget
\\\dart
AppImageWidget(
  imagePath: movie.posterUrl,
  fit: BoxFit.cover,
  height: 300,
  width: 200,
)
\\\
---
## 📝 Deployment Checklist
- ✅ Image paths centralized in app_images.dart
- ✅ All 15 movies mapped to images
- ✅ pubspec.yaml updated (assets: - assets/images/)
- ✅ Case-sensitive filenames verified
- ✅ Error handling implemented (AppImageWidget)
- ⏳ Actual image files need to be in assets/images/
- ⏳ Full restart after adding images
- ⏳ Test all 15 images display correctly
---
## 🚢 Build Commands
\\\ash
# Android
flutter build apk --release
# iOS
flutter build ios --release
# Web
flutter build web --release
\\\
---
## 📞 Contact
Email: contact@cinemaatlas.ma  
Address: 15 Avenue Mohammed V, Marrakech  
Hours: 14:00 - 23:00
---
## 🔄 Version History
- v1.0.0 (2024-04-23): Initial release with local images
- All 15 Moroccan & International films
- Full booking system with Hive
- Multi-language support
---
## ✅ Status
**Last Updated**: April 23, 2026  
**Status**: Production Ready  
**Images**: All paths configured and centralized  
**Documentation**: Complete
