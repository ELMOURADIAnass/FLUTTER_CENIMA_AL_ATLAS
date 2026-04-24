import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../utils/theme.dart';

// Premium testimonial card widget with cinema styling
class TestimonialCard extends StatefulWidget {
  final Testimonial testimonial;

  const TestimonialCard({
    super.key,
    required this.testimonial,
  });

  @override
  State<TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<TestimonialCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.3),
              blurRadius: _isHovered ? 16 : 8,
              offset: Offset(0, _isHovered ? 8 : 4),
              spreadRadius: _isHovered ? 1 : 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium star rating with yellow accent
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                final isFilled = index < widget.testimonial.rating.floor();
                final isHalf = index == widget.testimonial.rating.floor() &&
                    widget.testimonial.rating % 1 != 0;

                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    isFilled
                        ? Icons.star_rounded
                        : isHalf
                            ? Icons.star_half_rounded
                            : Icons.star_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),
            // Quote with italic styling
            Text(
              '"${widget.testimonial.text}"',
              style: AppTypography.body.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textPrimary,
                height: 1.6,
                fontSize: 15,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            // Author section
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(widget.testimonial.avatarUrl),
                    onBackgroundImageError: (context, error) {
                      // Fallback to initials if image fails
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.testimonial.name,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Client vérifié',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
