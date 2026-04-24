import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/movie.dart';
import '../providers/language_provider.dart';
import '../utils/theme.dart';
import 'booking_modal.dart';
import 'package:provider/provider.dart';

// Data table for screening schedule
class ScreeningTable extends StatelessWidget {
  final List<Screening> screenings;

  const ScreeningTable({super.key, required this.screenings});

  @override
  Widget build(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return _buildMobileList(context, localizations);
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.tableBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.tableDivider),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.tableHeaderBackground),
          headingRowHeight: 56,
          dataRowColor: WidgetStateProperty.all(AppColors.tableBackground),
          dataRowMinHeight: 56,
          dataRowMaxHeight: 56,
          dividerThickness: 1,
          columns: [
            DataColumn(
              label: Text(
                localizations.film,
                style: AppTypography.overline.copyWith(
                  color: AppColors.tableHeaderText,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                localizations.date,
                style: AppTypography.overline.copyWith(
                  color: AppColors.tableHeaderText,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                localizations.time,
                style: AppTypography.overline.copyWith(
                  color: AppColors.tableHeaderText,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                localizations.hall,
                style: AppTypography.overline.copyWith(
                  color: AppColors.tableHeaderText,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                localizations.language,
                style: AppTypography.overline.copyWith(
                  color: AppColors.tableHeaderText,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                localizations.price,
                style: AppTypography.overline.copyWith(
                  color: AppColors.tableHeaderText,
                ),
              ),
            ),
            const DataColumn(label: Text('')),
          ],
          rows: screenings.map((screening) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          screening.movie.posterUrl,
                          width: 40,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 40,
                            height: 56,
                            color: AppColors.surfaceLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          screening.movie.title,
                          style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(Text(
                  DateFormat('dd/MM/yyyy').format(screening.date),
                  style: AppTypography.body,
                )),
                DataCell(Text(
                  screening.time,
                  style: AppTypography.body.copyWith(color: AppColors.primary),
                )),
                DataCell(Text(screening.hall, style: AppTypography.body)),
                DataCell(Text(screening.language, style: AppTypography.body)),
                DataCell(Text(
                  '${screening.price.toInt()} MAD',
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                )),
                DataCell(
                  ElevatedButton(
                    onPressed: () => _showBookingModal(context, screening.movie),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.tableHeaderText,
                      minimumSize: const Size(80, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(localizations.reserve),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, dynamic localizations) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: screenings.length,
      separatorBuilder: (context, index) => const Divider(color: AppColors.tableDivider),
      itemBuilder: (context, index) {
        final screening = screenings[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              screening.movie.posterUrl,
              width: 50,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 70,
                color: AppColors.surfaceLight,
              ),
            ),
          ),
          title: Text(
            screening.movie.title,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${DateFormat('dd/MM').format(screening.date)} • ${screening.time} • ${screening.hall}',
            style: AppTypography.bodySmall,
          ),
          trailing: ElevatedButton(
            onPressed: () => _showBookingModal(context, screening.movie),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.tableHeaderText,
              minimumSize: const Size(60, 36),
            ),
            child: Text(localizations.reserve),
          ),
        );
      },
    );
  }

  void _showBookingModal(BuildContext context, Movie movie) {
    showDialog(
      context: context,
      builder: (context) => BookingModal(movie: movie),
    );
  }
}
