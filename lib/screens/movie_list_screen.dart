import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../utils/movie_database.dart';
import '../utils/theme.dart';
import '../widgets/app_image_widget.dart';
import 'movie_detail_screen.dart';

/// Movie List Screen with GridView display
///
/// Displays all movies in an organized grid layout with:
/// - Movie posters
/// - Title, session time, room, and price
/// - Click to navigate to detail screen
/// - Filtering by category
/// - Search functionality

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  /// Currently selected category filter
  MovieCategory _selectedCategory = MovieCategory.all;

  /// Search query
  String _searchQuery = '';

  /// Get filtered movies based on category and search
  List<Movie> _getFilteredMovies() {
    List<Movie> movies = MovieDatabase.getMoviesByCategory(_selectedCategory);

    if (_searchQuery.isNotEmpty) {
      movies = movies
          .where((movie) =>
              movie.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              movie.director
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = _getFilteredMovies();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Cinema Atlas',
          style: AppTypography.h4.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter pills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryPill(
                    MovieCategory.all,
                    'All',
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryPill(
                    MovieCategory.moroccan,
                    'Moroccan',
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryPill(
                    MovieCategory.international,
                    'International',
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryPill(
                    MovieCategory.newReleases,
                    'New',
                  ),
                ],
              ),
            ),
          ),

          // Movies grid
          Expanded(
            child: filteredMovies.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filteredMovies.length,
                    itemBuilder: (context, index) {
                      return _buildMovieCard(
                        context,
                        filteredMovies[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Build category filter pill
  Widget _buildCategoryPill(MovieCategory category, String label) {
    final isSelected = _selectedCategory == category;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCategory = category;
            _searchQuery = '';
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceLight,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.tableHeaderText : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  /// Build individual movie card
  Widget _buildMovieCard(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        // Navigate to detail screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: movie),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie poster image
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Image
                      AppImageWidget(
                        imagePath: movie.posterUrl,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        errorWidget: Container(
                          color: AppColors.surfaceLight,
                          child: Center(
                            child: Icon(
                              Icons.movie_outlined,
                              size: 40,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),

                      // Overlay gradient for text readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color.fromARGB(179, 0, 0, 0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Movie details
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Session time and price in row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                movie.showtimes.first,
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),

                          // Price
                          Text(
                            '${movie.price.toStringAsFixed(0)} DH',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Genre
                      Text(
                        movie.genre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 12,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            movie.rating.toStringAsFixed(1),
                            style: AppTypography.bodySmall,
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
      ),
    );
  }

  /// Build empty state when no movies found
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            size: 64,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No movies found',
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search',
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }

  /// Show search dialog
  Future<void> _showSearchDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        String tempQuery = _searchQuery;
        final controller = TextEditingController(text: _searchQuery);

        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Search Movies',
            style: AppTypography.h4.copyWith(color: AppColors.textPrimary),
          ),
          content: TextField(
            autofocus: true,
            controller: controller,
            onChanged: (value) {
              tempQuery = value;
            },
            style: AppTypography.body.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search by title or director...',
              hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.primary,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.dispose();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = tempQuery;
                  _selectedCategory = MovieCategory.all;
                });
                controller.dispose();
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}

