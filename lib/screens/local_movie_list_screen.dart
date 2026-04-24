import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../data/local_movie_database.dart';
import '../models/movie_local.dart';
import '../utils/theme.dart';

class LocalMovieListScreen extends StatefulWidget {
  const LocalMovieListScreen({super.key});

  @override
  State<LocalMovieListScreen> createState() => _LocalMovieListScreenState();
}

class _LocalMovieListScreenState extends State<LocalMovieListScreen> {
  late List<MovieLocal> movies;
  String? selectedSalle;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    movies = LocalMovieDatabase.getAllMovies();
  }

  void _applyFilters() {
    setState(() {
      movies = LocalMovieDatabase.getAllMovies();

      if (selectedSalle != null) {
        movies = movies.where((m) => m.salle == selectedSalle).toList();
      }

      if (selectedTime != null) {
        movies = movies.where((m) => m.sessionTime == selectedTime).toList();
      }
    });
  }

  void _resetFilters() {
    setState(() {
      selectedSalle = null;
      selectedTime = null;
      movies = LocalMovieDatabase.getAllMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cinema Al-ATLAS - Local Movies'),
        backgroundColor: AppColors.background,
        elevation: 8,
        shadowColor: AppColors.secondary.withAlpha(76),
      ),
      body: Column(
        children: [
          // Filter section
          _buildFilterSection(),
          // Movies grid
          Expanded(
            child: movies.isEmpty
                ? _buildEmptyState()
                : _buildMoviesGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    final salles = LocalMovieDatabase.getUniqueSalles();
    final times = LocalMovieDatabase.getUniqueTimes();

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salle filter
          Text(
            'Filter by Salle',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Salles'),
                  selected: selectedSalle == null,
                  onSelected: (_) => _resetFilters(),
                  backgroundColor: AppColors.background,
                  selectedColor: AppColors.secondary,
                ),
                const SizedBox(width: 8),
                ...salles.map((salle) {
                  final isSelected = selectedSalle == salle;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(salle),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => selectedSalle = salle);
                        _applyFilters();
                      },
                      backgroundColor: AppColors.background,
                      selectedColor: AppColors.secondary,
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Time filter
          Text(
            'Filter by Session Time',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Times'),
                  selected: selectedTime == null,
                  onSelected: (_) => _resetFilters(),
                  backgroundColor: AppColors.background,
                  selectedColor: AppColors.secondary,
                ),
                const SizedBox(width: 8),
                ...times.map((time) {
                  final isSelected = selectedTime == time;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(time),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => selectedTime = time);
                        _applyFilters();
                      },
                      backgroundColor: AppColors.background,
                      selectedColor: AppColors.secondary,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 375),
          columnCount: 2,
          child: ScaleAnimation(
            child: FadeInAnimation(
              child: _buildMovieCard(movies[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMovieCard(MovieLocal movie) {
    return GestureDetector(
      onTap: () => _navigateToReservation(movie),
      child: Card(
        color: AppColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  color: AppColors.background,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image with error handling
                    Image.asset(
                      movie.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.background.withAlpha(150),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Movie info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Details row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Time and salle
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.sessionTime,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              movie.salle,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        // Price
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withAlpha(51),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${movie.price.toStringAsFixed(0)} DH',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.surfaceLight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: AppColors.secondary.withAlpha(127),
          ),
          const SizedBox(height: 8),
          Text(
            'Image not found',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_filter_outlined,
            size: 64,
            color: AppColors.secondary.withAlpha(127),
          ),
          const SizedBox(height: 16),
          const Text(
            'No movies found',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _resetFilters,
            icon: const Icon(Icons.clear),
            label: const Text('Reset Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToReservation(MovieLocal movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocalMovieDetailScreen(movie: movie),
      ),
    );
  }
}

// Movie Detail/Reservation Screen
class LocalMovieDetailScreen extends StatefulWidget {
  final MovieLocal movie;

  const LocalMovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  State<LocalMovieDetailScreen> createState() => _LocalMovieDetailScreenState();
}

class _LocalMovieDetailScreenState extends State<LocalMovieDetailScreen> {
  int selectedSeats = 1;
  String? customerName;
  String? customerEmail;

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.movie.price * selectedSeats;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.movie.title),
        backgroundColor: AppColors.background,
        elevation: 8,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Movie poster
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
              ),
              child: Image.asset(
                widget.movie.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 80,
                      color: AppColors.secondary.withAlpha(127),
                    ),
                  );
                },
              ),
            ),
            // Movie details
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Info grid
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Session Time',
                          widget.movie.sessionTime,
                          Icons.schedule,
                        ),
                        const Divider(height: 16, color: AppColors.border),
                        _buildInfoRow(
                          'Salle',
                          widget.movie.salle,
                          Icons.door_front_door,
                        ),
                        const Divider(height: 16, color: AppColors.border),
                        _buildInfoRow(
                          'Price',
                          '${widget.movie.price.toStringAsFixed(0)} DH',
                          Icons.attach_money,
                        ),
                        if (widget.movie.duration != null) ...[
                          const Divider(height: 16, color: AppColors.border),
                          _buildInfoRow(
                            'Duration',
                            widget.movie.duration!,
                            Icons.timer_outlined,
                          ),
                        ],
                        if (widget.movie.director != null) ...[
                          const Divider(height: 16, color: AppColors.border),
                          _buildInfoRow(
                            'Director',
                            widget.movie.director!,
                            Icons.person_outlined,
                          ),
                        ],
                        if (widget.movie.genre != null) ...[
                          const Divider(height: 16, color: AppColors.border),
                          _buildInfoRow(
                            'Genre',
                            widget.movie.genre!,
                            Icons.category_outlined,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Seat selection
                  const Text(
                    'Number of Seats',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: selectedSeats > 1
                            ? () => setState(() => selectedSeats--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.secondary,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          selectedSeats.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: selectedSeats < 10
                            ? () => setState(() => selectedSeats++)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Total price
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.secondary.withAlpha(76),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Price',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${totalPrice.toStringAsFixed(0)} DH',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Reserve button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showReservationConfirm,
                      icon: const Icon(Icons.confirmation_number_outlined),
                      label: const Text('Complete Reservation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showReservationConfirm() {
    final totalPrice = widget.movie.price * selectedSeats;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Confirm Reservation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Movie: ${widget.movie.title}',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: ${widget.movie.sessionTime}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Salle: ${widget.movie.salle}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Seats: $selectedSeats',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              'Total: ${totalPrice.toStringAsFixed(0)} DH',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.background,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reservation confirmed for ${widget.movie.title}!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
    // Navigate back after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}

