import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/language_provider.dart';
import '../providers/reservation_provider.dart';
import '../utils/theme.dart';

class ReservationHistoryScreen extends StatefulWidget {
  const ReservationHistoryScreen({super.key});

  @override
  State<ReservationHistoryScreen> createState() => _ReservationHistoryScreenState();
}

class _ReservationHistoryScreenState extends State<ReservationHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          context.read<LanguageProvider>().localizations.reservations,
          style: AppTypography.h4.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 8,
        shadowColor: AppColors.primary.withValues(alpha: 0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ReservationProvider>(
        builder: (context, reservationProvider, _) {
          final reservations = reservationProvider.reservations;

          if (!reservationProvider.hasReservations) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    child: _buildReservationCard(
                      context,
                      reservations[index],
                      index,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.event_seat_outlined,
              size: 80,
              color: AppColors.secondary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            localizations.noReservations,
            style: AppTypography.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            localizations.noReservationsDesc,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.movie_filter),
            label: Text(localizations.browseMovies),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(
    BuildContext context,
    Reservation reservation,
    int index,
  ) {
    final localizations = context.read<LanguageProvider>().localizations;

    return Dismissible(
      key: Key(reservation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          Icons.delete_outline,
          color: AppColors.tableHeaderText,
          size: 28,
        ),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmation(context, localizations);
      },
      onDismissed: (direction) {
        context.read<ReservationProvider>().deleteReservation(reservation.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.reservationDeleted),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.error,
          ),
        );
      },
      child: Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
           decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
             border: Border.all(
               color: AppColors.primary.withValues(alpha: 0.1),
               width: 1,
             ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                // Header with poster
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                       colors: [
                         AppColors.primary.withValues(alpha: 0.1),
                         AppColors.primary.withValues(alpha: 0.05),
                       ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (reservation.moviePosterUrl.isNotEmpty)
                        Image.network(
                          reservation.moviePosterUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPosterPlaceholder(),
                        )
                      else
                        _buildPosterPlaceholder(),
                      // Overlay with gradient
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                             colors: [
                               Colors.transparent,
                               AppColors.background.withValues(alpha: 0.8),
                             ],
                          ),
                        ),
                      ),
                      // Film name
                      Positioned(
                        bottom: 12,
                        left: 16,
                        right: 16,
                        child: Text(
                          reservation.filmName,
                          style: AppTypography.h4.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Details section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Time and Hall row
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              Icons.access_time,
                              localizations.time,
                              reservation.sessionTime,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDetailItem(
                              Icons.door_front_door,
                              localizations.hall,
                              reservation.salle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Seats and Language row
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              Icons.event_seat,
                              localizations.seats,
                              '${reservation.seats}',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDetailItem(
                              Icons.language,
                              localizations.language,
                              reservation.language,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Price and Date row
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              Icons.attach_money,
                              localizations.price,
                              '${reservation.totalPrice.toStringAsFixed(2)} DH',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDetailItem(
                              Icons.calendar_today,
                              localizations.date,
                              _formatDate(reservation.createdAt),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.secondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPosterPlaceholder() {
    return Container(
      color: AppColors.surfaceLight,
      child: Center(
        child: Icon(
          Icons.movie,
          size: 60,
          color: AppColors.secondary.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(
    BuildContext context,
    var localizations,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          localizations.deleteReservation,
          style: AppTypography.h4.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          localizations.deleteReservationConfirm,
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              localizations.cancel,
              style: AppTypography.body.copyWith(color: AppColors.secondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              localizations.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (targetDate == today) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (targetDate == yesterday) {
      return 'Hier';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

