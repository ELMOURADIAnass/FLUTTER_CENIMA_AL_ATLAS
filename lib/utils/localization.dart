// Localization data for Cinema Atlas (French, English, Arabic)
class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  String get home => _getLocalized('Accueil', 'Home', 'الرئيسية');
  String get movies => _getLocalized('Films', 'Movies', 'الأفلام');
  String get schedule => _getLocalized('Calendrier', 'Schedule', 'الجدول');
  String get about => _getLocalized('A propos', 'About', 'عنّا');
  String get contact => _getLocalized('Contact', 'Contact', 'اتصل');
  String get bookNow => _getLocalized('Reserver maintenant', 'Book Now', 'احجز الآن');
  String get reserve => _getLocalized('Reserver', 'Reserve', 'احجز');
  String get featuredMovies => _getLocalized('Films a l\'affiche', 'Now Showing', 'الأفلام المعروضة');
  String get catalog => _getLocalized('Notre Catalogue', 'Our Catalog', 'كتالوجنا');
  String get scheduleTitle => _getLocalized('Calendrier des Projections', 'Screening Schedule', 'جدول العروض');
  String get aboutTitle => _getLocalized('A propos de Cinema Al-ATLAS', 'About Cinema Al-ATLAS', 'عن سينما الأطلس');
  String get testimonials => _getLocalized('Ce que disent nos spectateurs', 'What Our Viewers Say', 'آراء مشاهدينا');
  String get contactTitle => _getLocalized('Contactez-nous', 'Contact Us', 'تواصل معنا');
  String get newsletter => _getLocalized('Newsletter', 'Newsletter', 'النشرة البريدية');
  String get subscribe => _getLocalized('S\'abonner', 'Subscribe', 'اشترك');
  String get film => _getLocalized('Film', 'Film', 'الفيلم');
  String get date => _getLocalized('Date', 'Date', 'التاريخ');
  String get time => _getLocalized('Heure', 'Time', 'الوقت');
  String get hall => _getLocalized('Salle', 'Hall', 'القاعة');
  String get language => _getLocalized('Langue', 'Language', 'اللغة');
  String get price => _getLocalized('Prix', 'Price', 'السعر');
  String get duration => _getLocalized('Duree', 'Duration', 'المدة');
  String get rating => _getLocalized('Note', 'Rating', 'التقييم');
  String get genre => _getLocalized('Genre', 'Genre', 'التصنيف');
  String get director => _getLocalized('Realisateur', 'Director', 'المخرج');
  String get year => _getLocalized('Annee', 'Year', 'السنة');
  String get synopsis => _getLocalized('Synopsis', 'Synopsis', 'الملخص');
  String get close => _getLocalized('Fermer', 'Close', 'إغلاق');
  String confirmBooking(String movie) => _getLocalized(
    'Confirmer la reservation pour $movie ?',
    'Confirm booking for $movie?',
    'تأكيد الحجز لفيلم $movie؟',
  );
  String get bookingConfirmed => _getLocalized('Reservation confirmee !', 'Booking Confirmed!', 'تم تأكيد الحجز!');
  String get seats => _getLocalized('Places', 'Seats', 'المقاعد');
  String get selectSeats => _getLocalized('Selectionner les places', 'Select Seats', 'اختيار المقاعد');
  String get total => _getLocalized('Total', 'Total', 'المجموع');
  String get name => _getLocalized('Nom', 'Name', 'الاسم');
  String get email => _getLocalized('Email', 'Email', 'البريد');
  String get phone => _getLocalized('Telephone', 'Phone', 'الهاتف');
  String get send => _getLocalized('Envoyer', 'Send', 'إرسال');
  String get message => _getLocalized('Message', 'Message', 'الرسالة');
  String get address => _getLocalized('Adresse', 'Address', 'العنوان');
  String get hours => _getLocalized('Horaires', 'Hours', 'الساعات');
  String get allDays => _getLocalized('Tous les jours : 14h00 - 23h00', 'Daily: 2:00 PM - 11:00 PM', 'يومياً: 14:00 - 23:00');
  String get quickLinks => _getLocalized('Liens rapides', 'Quick Links', 'روابط سريعة');
  String get followUs => _getLocalized('Suivez-nous', 'Follow Us', 'تابعنا');
  String get yourName => _getLocalized('Votre nom', 'Your name', 'اسمك');
  String get yourEmail => _getLocalized('Votre email', 'Your email', 'بريدك');
  String get yourMessage => _getLocalized('Votre message', 'Your message', 'رسالتك');

  // Hero section
  String get heroTitle => _getLocalized(
    'Une experience cinematographique authentique marocaine',
    'An Authentic Moroccan Cinematic Experience',
    'تجربة سينمائية مغربية أصيلة',
  );
  String get heroSubtitle => _getLocalized(
    'Decouvrez la magie du cinema marocain dans un cadre traditionnel et moderne',
    'Discover the magic of Moroccan cinema in a traditional yet modern setting',
    'اكتشف سحر السينما المغربية في إطار تقليدي وعصري',
  );

  // About section
  String get aboutDescription => _getLocalized(
    'Fonde en 2023, le Cinema Al-ATLAS offre une experience cinematographique unique qui celebre l\'heritage culturel marocain tout en proposant des projections ultra-modernes. Notre mission est de creer un pont entre le cinema marocain traditionnel et contemporain, offrant une plateforme pour les films locaux et internationaux.',
    'Founded in 2023, Cinema Al-ATLAS offers a unique cinematic experience celebrating Moroccan cultural heritage while featuring state-of-the-art screenings. Our mission bridges traditional and contemporary Moroccan cinema, providing a platform for local and international films.',
    'تأسست سينما الأطلس في عام 2023 لتقدم تجربة سينمائية فريدة تحتفل بالتراث الثقافي المغربي مع عروض حديثة للغاية. مهمتنا هي بناء جسر بين السينما المغربية التقليدية والمعاصرة، مع توفير منصة للأفلام المحلية والعالمية.',
  );

  // Features
  String get feature4K => _getLocalized('Projection 4K Ultra HD', '4K Ultra HD Projection', 'عرض 4K الترا HD');
  String get featureSound => _getLocalized('Son Dolby Atmos', 'Dolby Atmos Sound', 'صوت دولبي أتموس');
  String get featureSeats => _getLocalized('Sieges premium', 'Premium Seats', 'مقاعد متميزة');
   String get featureCafe => _getLocalized('Cafe traditionnel', 'Traditional Cafe', 'مقهى تقليدي');

   // Reservation strings
   String get reservations => _getLocalized('Mes Reservations', 'My Reservations', 'حجوزاتي');
   String get noReservations => _getLocalized('Aucune reservation', 'No Reservations', 'لا توجد حجوزات');
   String get noReservationsDesc => _getLocalized(
     'Vous n\'avez pas encore de reservations. Commencez a explorer nos films !',
     'You have no reservations yet. Start exploring our movies!',
     'لم تقم بأي حجوزات حتى الآن. ابدأ بالبحث عن أفلامنا!',
   );
   String get browseMovies => _getLocalized('Parcourir les films', 'Browse Movies', 'تصفح الأفلام');
   String get reservationDeleted => _getLocalized('Reservation supprimee', 'Reservation Deleted', 'تم حذف الحجز');
   String get deleteReservation => _getLocalized('Supprimer la reservation ?', 'Delete Reservation?', 'حذف الحجز؟');
   String get deleteReservationConfirm => _getLocalized(
     'Êtes-vous certain de vouloir supprimer cette reservation ?',
     'Are you sure you want to delete this reservation?',
     'هل أنت متأكد من رغبتك في حذف هذا الحجز؟',
   );
   String get cancel => _getLocalized('Annuler', 'Cancel', 'إلغاء');
   String get delete => _getLocalized('Supprimer', 'Delete', 'حذف');

   String _getLocalized(String fr, String en, String ar) {
    switch (languageCode) {
      case 'ar':
        return ar;
      case 'en':
        return en;
      default:
        return fr;
    }
  }
}

// Supported languages
class SupportedLanguages {
  static const List<Map<String, String>> languages = [
    {'code': 'fr', 'name': 'Français', 'native': 'Français'},
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'ar', 'name': 'Arabic', 'native': 'العربية'},
  ];
}
