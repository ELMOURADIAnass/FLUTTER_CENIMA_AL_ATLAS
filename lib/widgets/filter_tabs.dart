import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/language_provider.dart';
import '../providers/movie_provider.dart';
import '../utils/theme.dart';

// Filter tabs for movie categories with smooth animations
class FilterTabs extends StatelessWidget {
  const FilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<MovieProvider, LanguageProvider>(
      builder: (context, movieProvider, langProvider, child) {
        final categories = MovieCategory.values;
        final selectedCategory = movieProvider.selectedCategory;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              final isSelected = category == selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => movieProvider.setCategory(category),
                    borderRadius: BorderRadius.circular(28),
                    highlightColor: AppColors.primary.withValues(alpha: 0.1),
                    splashColor: AppColors.primary.withValues(alpha: 0.2),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? AppColors.accentGradient
                            : null,
                        color: isSelected
                            ? null
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.border,
                          width: 1.5,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                              spreadRadius: 1,
                            ),
                        ],
                      ),
                      child: Text(
                        category.getLabel(langProvider.currentLanguage),
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.background
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w900
                              : FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: isSelected ? 0.3 : 0,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
