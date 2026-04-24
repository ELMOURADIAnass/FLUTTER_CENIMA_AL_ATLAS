import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../utils/theme.dart';

// Premium movie card widget with hover effects and cinema styling
class MovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final VoidCallback? onBook;
  final bool showBookButton;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.onBook,
    this.showBookButton = true,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..translateByDouble(0, _isHovered ? -8 : 0, 0, 1),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered 
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.4),
                blurRadius: _isHovered ? 24 : 12,
                offset: Offset(0, _isHovered ? 12 : 6),
                spreadRadius: _isHovered ? 2 : 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster image with overlay
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildMovieImage(widget.movie.posterUrl),
                      // Premium gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.background.withValues(alpha: 0.7),
                              AppColors.background.withValues(alpha: 0.95),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0, 0.5, 1],
                          ),
                        ),
                      ),
                      // Hover overlay with cinema aesthetic
                      if (_isHovered)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.1),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      // Rating badge - YELLOW ACCENT
                      Positioned(
                        top: 12,
                        right: 12,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: _isHovered ? 0.6 : 0.3),
                                blurRadius: _isHovered ? 12 : 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: AppColors.background,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.movie.rating.toString(),
                                style: const TextStyle(
                                  color: AppColors.background,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Category badge
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.background.withValues(alpha: 0.85),
                            border: Border.all(color: AppColors.primary, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.movie.genre,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Movie info section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie.title,
                        style: AppTypography.h4.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.movie.duration,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Price and booking button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.movie.price.toInt()} MAD',
                            style: AppTypography.h4.copyWith(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          if (widget.showBookButton)
                            AnimatedScale(
                              scale: _isHovered ? 1.05 : 1.0,
                              duration: const Duration(milliseconds: 250),
                              child: SizedBox(
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: widget.onBook,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.background,
                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                    elevation: _isHovered ? 6 : 2,
                                  ),
                                  child: const Text(
                                    'RESERVER',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
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
      ),
    );
  }

    Widget _buildPlaceholder() {
      return Container(
        color: AppColors.surfaceLight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: 48,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 8),
              Text(
                'Image',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ FIXED: Improved image loading with better error handling
    Widget _buildMovieImage(String imageUrl) {
      if (imageUrl.startsWith('http')) {
        // Network image (URL)
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } else if (imageUrl.startsWith('assets/')) {
        // Local asset image - with error handling fallback
        return Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // If asset doesn't exist, show colored placeholder with title
            return _buildColoredPlaceholder(widget.movie.title);
          },
        );
      }
      return _buildPlaceholder();
    }

    // ✅ NEW: Colored placeholder when images are missing
    Widget _buildColoredPlaceholder(String title) {
      final colors = [
        const Color(0xFF4A90E2),
        const Color(0xFFE25759),
        const Color(0xFFF5A623),
        const Color(0xFF7ED321),
        const Color(0xFF9013FE),
        const Color(0xFF50E3C2),
        const Color(0xFFBD10E0),
        const Color(0xFF417505),
      ];
      
      final colorIndex = title.hashCode % colors.length;
      final color = colors[colorIndex];

       return Container(
         color: color.withValues(alpha: 0.8),
         child: Center(
           child: Padding(
             padding: const EdgeInsets.all(16),
             child: Text(
               title,
               textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
 }
