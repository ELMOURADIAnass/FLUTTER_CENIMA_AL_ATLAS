import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/theme.dart';

// Language switcher widget with Moroccan flag style
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageButton(context, 'FR', 'fr', provider),
              _buildLanguageDivider(),
              _buildLanguageButton(context, 'EN', 'en', provider),
              _buildLanguageDivider(),
              _buildLanguageButton(context, 'AR', 'ar', provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    String label,
    String code,
    LanguageProvider provider,
  ) {
    final isSelected = provider.currentLanguage == code;
    return InkWell(
      onTap: () => provider.setLanguage(code),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
         decoration: BoxDecoration(
           color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
           borderRadius: BorderRadius.circular(12),
         ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textMuted,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDivider() {
    return Container(
      width: 1,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: AppColors.surfaceLight,
    );
  }
}
