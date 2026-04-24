import 'package:flutter/material.dart';
import '../utils/theme.dart';

// Premium section title with cinema-inspired styling
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool centered;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.centered = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 48),
      child: Column(
        crossAxisAlignment:
            centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // Premium accent line with gradient
          Container(
            height: 5,
            width: 80,
            margin: EdgeInsets.only(
              bottom: 20,
              left: centered ? 0 : 0,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          // Main title
          Text(
            title.toUpperCase(),
            style: AppTypography.h2.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 1,
              fontWeight: FontWeight.w900,
            ),
            textAlign: centered ? TextAlign.center : TextAlign.left,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            Text(
              subtitle!,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
              textAlign: centered ? TextAlign.center : TextAlign.left,
            ),
          ],
        ],
      ),
    );
  }
}
