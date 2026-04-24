import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/language_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/movie_provider.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/booking_modal.dart';
import '../widgets/filter_tabs.dart';
import '../widgets/movie_card.dart';
import '../widgets/screening_table.dart';
import '../widgets/section_title.dart';
import '../widgets/testimonial_card.dart';
import 'reservation_history_screen.dart';

// Main home screen with all sections
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   final ScrollController _scrollController = ScrollController();
   final GlobalKey _heroKey = GlobalKey();
   final GlobalKey _moviesKey = GlobalKey();
   final GlobalKey _scheduleKey = GlobalKey();
   final GlobalKey _aboutKey = GlobalKey();
   final GlobalKey _contactKey = GlobalKey();
   String _activeSection = 'home';

   @override
   void initState() {
     super.initState();
     // ✅ FIXED: Added optimized scroll listener to track visible section
     _scrollController.addListener(_updateActiveSection);
   }

   @override
   void dispose() {
     _scrollController.removeListener(_updateActiveSection);
     _scrollController.dispose();
     super.dispose();
   }

   void _updateActiveSection() {
     // Determine which section is currently visible
     final sections = [
       ('home', _heroKey),
       ('movies', _moviesKey),
       ('schedule', _scheduleKey),
       ('about', _aboutKey),
       ('contact', _contactKey),
     ];

     for (var (name, key) in sections) {
       final RenderObject? renderObject = key.currentContext?.findRenderObject();
       if (renderObject != null) {
         final box = renderObject as RenderBox;
         final offset = box.localToGlobal(Offset.zero);
         // If section is in upper half of viewport, mark it as active
         if (offset.dy < MediaQuery.of(context).size.height * 0.4) {
           if (_activeSection != name) {
             setState(() => _activeSection = name);
           }
           break;
         }
       }
     }
   }


    void _scrollToSection(GlobalKey key, String sectionName) {
      final RenderObject? renderObject = key.currentContext?.findRenderObject();
      if (renderObject != null) {
        setState(() => _activeSection = sectionName);
        renderObject.showOnScreen(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          _buildAppBar(context),
          // Hero Section
          SliverToBoxAdapter(key: _heroKey, child: _buildHeroSection(context)),
          // Featured Movies
          SliverToBoxAdapter(key: _moviesKey, child: _buildFeaturedMovies(context)),
          // Movie Catalog with Filters
          SliverToBoxAdapter(child: _buildCatalogSection(context)),
          // Schedule Section
          SliverToBoxAdapter(key: _scheduleKey, child: _buildScheduleSection(context)),
          // About Section
          SliverToBoxAdapter(key: _aboutKey, child: _buildAboutSection(context)),
          // Testimonials
          SliverToBoxAdapter(child: _buildTestimonialsSection(context)),
          // Contact Section
          SliverToBoxAdapter(key: _contactKey, child: _buildContactSection(context)),
          // Footer
          SliverToBoxAdapter(child: _buildFooter(context)),
        ],
      ),
    );
  }

      Widget _buildAppBar(BuildContext context) {
        final localizations = context.watch<LanguageProvider>().localizations;

        return SliverAppBar(
          pinned: true,
          floating: false,
          elevation: 16,
          backgroundColor: AppColors.background,
          shadowColor: AppColors.primary.withValues(alpha: 0.2),
          title: Row(
            children: [
              // Premium logo with yellow accent
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.movie_rounded,
                  color: AppColors.background,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Cinema Al-ATLAS',
                style: AppTypography.h4.copyWith(
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          toolbarHeight: 76,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
              height: 0,
              color: AppColors.background,
            ),
          ),
          actions: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavItem(localizations.home, () => _scrollToSection(_heroKey, 'home'), _activeSection == 'home'),
                    _buildNavItem(localizations.movies, () => _scrollToSection(_moviesKey, 'movies'), _activeSection == 'movies'),
                    _buildNavItem(localizations.schedule, () => _scrollToSection(_scheduleKey, 'schedule'), _activeSection == 'schedule'),
                    _buildNavItem(localizations.about, () => _scrollToSection(_aboutKey, 'about'), _activeSection == 'about'),
                    _buildNavItem(localizations.contact, () => _scrollToSection(_contactKey, 'contact'), _activeSection == 'contact'),
                    _buildNavItem(localizations.reservations, () => _navigateToReservations(context), false),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
            // User profile menu
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                if (authProvider.isLoggedIn && authProvider.currentUser != null) {
                  return _buildUserMenu(context, authProvider.currentUser!.fullName);
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(width: 16),
          ],
        );
      }

    void _navigateToReservations(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ReservationHistoryScreen(),
        ),
      );
    }

         Widget _buildNavItem(String label, VoidCallback onTap, bool isActive) {
           return GestureDetector(
             onTap: onTap,
             child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   AnimatedDefaultTextStyle(
                     duration: const Duration(milliseconds: 250),
                     style: AppTypography.body.copyWith(
                       color: isActive ? AppColors.primary : AppColors.textSecondary,
                       fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                       fontSize: isActive ? 16 : 15,
                       letterSpacing: isActive ? 0.3 : 0,
                     ),
                     child: Text(label),
                   ),
                   if (isActive)
                     Container(
                       margin: const EdgeInsets.only(top: 6),
                       height: 3,
                       width: 28,
                       decoration: BoxDecoration(
                         gradient: AppColors.accentGradient,
                         borderRadius: BorderRadius.circular(2),
                         boxShadow: [
                           BoxShadow(
                             color: AppColors.primary.withValues(alpha: 0.5),
                             blurRadius: 8,
                             offset: const Offset(0, 2),
                           ),
                         ],
                       ),
                     ),
                 ],
               ),
             ),
           );
         }

      /// Build user profile dropdown menu
      Widget _buildUserMenu(BuildContext context, String userName) {
        return PopupMenuButton<String>(
          color: AppColors.surface,
          onSelected: (String value) {
            if (value == 'logout') {
              _showLogoutConfirmation(context);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              enabled: false,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          color: AppColors.tableHeaderText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          'Account',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: const [
                  Icon(Icons.logout, color: AppColors.primary),
                  SizedBox(width: 12),
                  Text(
                    'Logout',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: AppColors.tableHeaderText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }

      /// Show logout confirmation dialog
      void _showLogoutConfirmation(BuildContext context) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: const Text(
                'Logout',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              content: const Text(
                'Are you sure you want to logout?',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Close dialog
                    final authProvider = context.read<AuthProvider>();
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      }

  Widget _buildHeroSection(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.8,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const NetworkImage(ImageConstants.heroBackground),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.background.withValues(alpha: 0.6),
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium branding
              Text(
                'CINEMA AL-ATLAS',
                style: AppTypography.h1.copyWith(
                  color: AppColors.primary,
                  fontSize: 20,
                  letterSpacing: 6,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 20),
              // Main hero title with premium shadow effect
              Text(
                localizations.heroTitle,
                style: AppTypography.h1.copyWith(
                  fontSize: size.width > 600 ? 56 : 36,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                localizations.heroSubtitle,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 48),
              Row(
                children: [
                  // Primary CTA button with gradient
                  ElevatedButton.icon(
                    onPressed: () => _scrollToSection(_moviesKey, 'movies'),
                    icon: const Icon(Icons.confirmation_number_rounded),
                    label: Text(localizations.bookNow),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 22,
                      ),
                      elevation: 8,
                      shadowColor: AppColors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Secondary button with premium border
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_circle_outline_rounded),
                    label: const Text('Bande-annonce'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary, width: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedMovies(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;
    final featuredMovies = context.read<MovieProvider>().featuredMovies;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 48),
      color: AppColors.background,
      child: Column(
        children: [
          SectionTitle(title: localizations.featuredMovies),
          SizedBox(
            height: 450,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featuredMovies.length,
              separatorBuilder: (context, index) => const SizedBox(width: 28),
               itemBuilder: (context, index) {
                 return SizedBox(
                   width: 280,
                   child: AnimationConfiguration.staggeredList(
                     position: index,
                     duration: const Duration(milliseconds: 375),
                     child: SlideAnimation(
                       horizontalOffset: 50,
                       child: FadeInAnimation(
                         child: MovieCard(
                           movie: featuredMovies[index],
                           onBook: () => _showBooking(context, featuredMovies[index]),
                         ),
                       ),
                     ),
                   ),
                 );
               },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogSection(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;
    final filteredMovies = context.watch<MovieProvider>().filteredMovies;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 48),
      color: AppColors.surface,
      child: Column(
        children: [
          SectionTitle(title: localizations.catalog),
          const FilterTabs(),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 0.65,
              crossAxisSpacing: 28,
              mainAxisSpacing: 28,
            ),
            itemCount: filteredMovies.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: filteredMovies.length > 4 ? 4 : filteredMovies.length,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: MovieCard(
                      movie: filteredMovies[index],
                      onBook: () => _showBooking(context, filteredMovies[index]),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;
    final movies = context.read<MovieProvider>().movies;

    // Generate sample screenings
    final screenings = movies.take(5).map((movie) {
      return Screening(
        id: 'screen_${movie.id}',
        movie: movie,
        date: DateTime.now().add(const Duration(days: 1)),
        time: movie.showtimes.first,
        hall: 'Salle ${int.parse(movie.id) % 3 + 1}',
        language: movie.language,
        price: movie.price,
        availableSeats: 45,
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 48),
      child: Column(
        children: [
          SectionTitle(title: localizations.scheduleTitle),
          ScreeningTable(screenings: screenings),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 48),
      color: AppColors.background,
      child: Column(
        children: [
          SectionTitle(title: localizations.aboutTitle),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.aboutDescription,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildFeatureItem(Icons.movie_filter, localizations.feature4K),
                    _buildFeatureItem(Icons.spatial_audio, localizations.featureSound),
                    _buildFeatureItem(Icons.event_seat, localizations.featureSeats),
                    _buildFeatureItem(Icons.coffee, localizations.featureCafe),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    image: const DecorationImage(
                      image: NetworkImage(ImageConstants.heroBackground),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.background, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: AppTypography.body.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;

    final testimonials = [
      Testimonial(
        id: '1',
        name: 'Leila M.',
        avatarUrl: ImageConstants.avatar1,
        text: 'Une experience cinematographique exceptionnelle ! L\'ambiance du cinema est magique et les projections sont d\'une qualite remarquable.',
        rating: 5,
        date: DateTime(2024, 3, 15),
      ),
      Testimonial(
        id: '2',
        name: 'Karim B.',
        avatarUrl: ImageConstants.avatar2,
        text: 'Le Cinema Atlas est devenu mon lieu prefere a Marrakech. La selection de films marocains est excellente et le son Dolby Atmos est incroyable.',
        rating: 5,
        date: DateTime(2024, 3, 15),
      ),
      Testimonial(
        id: '3',
        name: 'Sophie R.',
        avatarUrl: ImageConstants.avatar3,
        text: 'Je recommande vivement ! Un beau melange entre tradition marocaine et technologie moderne. Le cafe traditionnel est un plus agreable.',
        rating: 4.5,
        date: DateTime(2024, 3, 15),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 48),
      color: AppColors.background,
      child: Column(
        children: [
          SectionTitle(title: localizations.testimonials),
          Wrap(
            spacing: 28,
            runSpacing: 28,
            children: testimonials.map((t) => SizedBox(
              width: 360,
              child: TestimonialCard(testimonial: t),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 48),
      color: AppColors.surface,
      child: Column(
        children: [
          SectionTitle(title: localizations.contactTitle),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildContactInfo(context),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: _buildContactForm(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem(Icons.location_on, localizations.address, AppConstants.address),
        const SizedBox(height: 20),
        _buildInfoItem(Icons.phone, localizations.phone, AppConstants.phone),
        const SizedBox(height: 20),
        _buildInfoItem(Icons.email, localizations.email, AppConstants.email),
        const SizedBox(height: 20),
        _buildInfoItem(Icons.access_time, localizations.hours, AppConstants.allDays),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.background, size: 24),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            style: AppTypography.body,
            decoration: InputDecoration(
              labelText: localizations.yourName,
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            style: AppTypography.body,
            decoration: InputDecoration(
              labelText: localizations.yourEmail,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            maxLines: 4,
            style: AppTypography.body,
            decoration: InputDecoration(
              labelText: localizations.yourMessage,
              prefixIcon: const Icon(Icons.message_outlined),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(localizations.send),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;

    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.newsletter,
                    style: AppTypography.h4.copyWith(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      SizedBox(
                        width: 280,
                        child: TextField(
                          style: AppTypography.body,
                          decoration: InputDecoration(
                            hintText: localizations.yourEmail,
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_forward_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    localizations.followUs,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _buildSocialIcon(Icons.facebook_rounded),
                      const SizedBox(width: 12),
                      _buildSocialIcon(Icons.camera_alt_rounded),
                      const SizedBox(width: 12),
                      _buildSocialIcon(Icons.movie_rounded),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Divider(
            color: AppColors.border,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 20),
          Text(
            '2024 Cinema Al-ATLAS. Tous droits reserves.',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(
        icon,
        size: 20,
        color: AppColors.primary,
      ),
    );
  }

  void _showBooking(BuildContext context, Movie movie) {
    showDialog(
      context: context,
      builder: (context) => BookingModal(movie: movie),
    );
  }
}
