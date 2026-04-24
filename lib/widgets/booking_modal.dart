import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../models/reservation.dart';
import '../models/room.dart';
import '../providers/booking_provider.dart';
import '../providers/language_provider.dart';
import '../providers/reservation_provider.dart';
import '../utils/theme.dart';

// Booking modal with room selection and capacity validation
class BookingModal extends StatefulWidget {
  final Movie movie;

  const BookingModal({super.key, required this.movie});

  @override
  State<BookingModal> createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  int _currentStep = 0;
  int selectedSeats = 1;
  String? selectedTime;
  Room? selectedRoom;
  bool _isConfirming = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize rooms from database
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.read<LanguageProvider>().localizations;
    final totalPrice = widget.movie.price * selectedSeats;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildStepContent(),
              ),
            ),
            // Footer
            _buildFooter(localizations, totalPrice),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
             child: Image.network(
               widget.movie.posterUrl,
               width: 60,
               height: 80,
               fit: BoxFit.cover,
               errorBuilder: (context, error, stackTrace) => Container(
                 width: 60,
                 height: 80,
                 color: AppColors.background,
                 child: const Icon(Icons.movie, color: AppColors.textMuted),
               ),
             ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movie.title,
                  style: AppTypography.h4.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.movie.duration} • ${widget.movie.language}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildTimeSelection();
      case 1:
        return _buildRoomSelection();
      case 2:
        return _buildSeatSelection();
      case 3:
        return _buildUserInfoForm();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choisir une seance',
          style: AppTypography.h4.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.movie.showtimes.map((time) {
            final isSelected = time == selectedTime;
            return ChoiceChip(
              label: Text(time),
              selected: isSelected,
              onSelected: (_) => setState(() => selectedTime = time),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.background,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.background : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRoomSelection() {
    final bookingProvider = context.watch<BookingProvider>();
    final rooms = bookingProvider.rooms;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choisir une salle',
          style: AppTypography.h4.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          'Capacite disponible pour ${selectedTime ?? ''}',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 16),
        ...rooms.map((room) {
          final isSelected = selectedRoom?.id == room.id;
          final availableSeats = selectedTime != null
              ? bookingProvider.getAvailableSeats(
                  room.id,
                  widget.movie.id,
                  DateTime.now(),
                  selectedTime!,
                )
              : room.capacity;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: availableSeats > 0
                  ? () => setState(() => selectedRoom = room)
                  : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : availableSeats > 0
                            ? AppColors.border
                            : AppColors.textMuted,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.theaters,
                      color: availableSeats > 0
                          ? (isSelected ? AppColors.primary : AppColors.textSecondary)
                          : AppColors.textMuted,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.name,
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: availableSeats > 0
                                  ? AppColors.textPrimary
                                  : AppColors.textMuted,
                            ),
                          ),
                          if (room.description != null)
                            Text(
                              room.description!,
                              style: AppTypography.caption,
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: availableSeats > 0 ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$availableSeats/${room.capacity}',
                        style: TextStyle(
                          color: availableSeats > 0 ? AppColors.primary : AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSeatSelection() {
    final bookingProvider = context.read<BookingProvider>();
    final maxSeats = selectedRoom != null && selectedTime != null
        ? bookingProvider.getAvailableSeats(
            selectedRoom!.id,
            widget.movie.id,
            DateTime.now(),
            selectedTime!,
          )
        : selectedRoom?.capacity ?? 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nombre de places',
          style: AppTypography.h4.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 8),
        if (selectedRoom != null)
          Text(
            'Salle: ${selectedRoom!.name} (max: $maxSeats)',
            style: AppTypography.bodySmall,
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: selectedSeats > 1
                  ? () => setState(() => selectedSeats--)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.primary,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                selectedSeats.toString(),
                style: AppTypography.h3,
              ),
            ),
            IconButton(
              onPressed: selectedSeats < maxSeats
                  ? () => setState(() => selectedSeats++)
                  : null,
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.primary,
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Seat map visualization
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    'ECRAN',
                    style: TextStyle(fontSize: 10, color: AppColors.background),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(4, (row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (col) {
                      final seatNumber = row * 6 + col + 1;
                      final isSelected = seatNumber <= selectedSeats;
                      return Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 14, color: AppColors.background)
                            : null,
                      );
                    }),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vos informations',
          style: AppTypography.h4.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _nameController,
          label: 'Nom complet',
          icon: Icons.person_outline,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _phoneController,
          label: 'Telephone',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        // Booking summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recapitulatif', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildSummaryRow('Film', widget.movie.title),
              _buildSummaryRow('Seance', selectedTime ?? ''),
              _buildSummaryRow('Salle', selectedRoom?.name ?? ''),
              _buildSummaryRow('Places', selectedSeats.toString()),
              const Divider(color: AppColors.border, height: 16),
              _buildSummaryRow('Total', '${(widget.movie.price * selectedSeats).toInt()} MAD', isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        labelStyle: const TextStyle(color: AppColors.textMuted),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(
            value,
            style: isBold
                ? AppTypography.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)
                : AppTypography.body,
          ),
        ],
      ),
    );
  }

   Widget _buildFooter(dynamic localizations, double totalPrice) {
     return Container(
       padding: const EdgeInsets.all(20),
       decoration: const BoxDecoration(
         color: AppColors.surfaceLight,
         border: Border(
           top: BorderSide(color: AppColors.border),
         ),
       ),
       child: Row(
         children: [
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               Text(localizations.total, style: AppTypography.bodySmall),
               Text(
                 '${totalPrice.toInt()} MAD',
                 style: AppTypography.h4.copyWith(color: AppColors.primary),
               ),
             ],
           ),
           const Spacer(),
           if (_currentStep > 0)
             TextButton(
               onPressed: _isConfirming ? null : () => setState(() => _currentStep--),
               child: const Text('Retour', style: TextStyle(color: AppColors.textSecondary)),
             ),
           const SizedBox(width: 12),
           ElevatedButton(
             onPressed: (_canProceed() && !_isConfirming) ? _handleNext : null,
             style: ElevatedButton.styleFrom(
               backgroundColor: AppColors.primary,
               foregroundColor: AppColors.background,
             ),
             child: _isConfirming
                 ? const SizedBox(
                     width: 20,
                     height: 20,
                     child: CircularProgressIndicator(
                       strokeWidth: 2,
                       valueColor: AlwaysStoppedAnimation(AppColors.background),
                     ),
                   )
                 : Text(_currentStep == 3 ? localizations.reserve : 'SUIVANT'),
           ),
         ],
       ),
     );
   }

   bool _canProceed() {
     switch (_currentStep) {
       case 0:
         return selectedTime != null;
       case 1:
         return selectedRoom != null;
       case 2:
         final bookingProvider = context.read<BookingProvider>();
         final maxSeats = selectedRoom != null && selectedTime != null
             ? bookingProvider.getAvailableSeats(
                 selectedRoom!.id,
                 widget.movie.id,
                 DateTime.now(),
                 selectedTime!,
               )
             : 0;
         return selectedSeats > 0 && selectedSeats <= maxSeats;
       case 3:
         // Validate name and email only (phone is optional)
         return _nameController.text.trim().isNotEmpty &&
             _emailController.text.trim().isNotEmpty &&
             _isValidEmail(_emailController.text.trim());
       default:
         return false;
     }
   }

   bool _isValidEmail(String email) {
     final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
     return regex.hasMatch(email);
   }

   void _handleNext() async {
     if (_currentStep < 3) {
       setState(() => _currentStep++);
     } else {
       await _confirmBooking();
     }
   }

    Future<void> _confirmBooking() async {
      if (selectedRoom == null || selectedTime == null) {
        _showErrorDialog('Erreur', 'Informations de reservation manquantes');
        return;
      }

      if (!_canProceed()) {
        _showErrorDialog('Validation', 'Veuillez remplir tous les champs requis');
        return;
      }

      setState(() => _isConfirming = true);

      try {
        final bookingProvider = context.read<BookingProvider>();
        // Normalize date to avoid millisecond mismatches in DB keys
        final now = DateTime.now();
        final bookingDate = DateTime(now.year, now.month, now.day);

        final screening = Screening(
          id: 'screen_${widget.movie.id}_$selectedTime',
          movie: widget.movie,
          date: bookingDate,
          time: selectedTime!,
          hall: selectedRoom!.name,
          language: widget.movie.language,
          price: widget.movie.price,
          availableSeats: bookingProvider.getAvailableSeats(
            selectedRoom!.id,
            widget.movie.id,
            bookingDate,
            selectedTime!,
          ),
        );

        final booking = Booking(
          id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
          screening: screening,
          roomId: selectedRoom!.id,
          roomName: selectedRoom!.name,
          customerName: _nameController.text.trim(),
          customerEmail: _emailController.text.trim(),
          customerPhone: _phoneController.text.trim(),
          seatCount: selectedSeats,
          totalPrice: widget.movie.price * selectedSeats,
          bookingDate: DateTime.now(),
        );

         final success = await bookingProvider.addBooking(booking);

         if (mounted) {
           setState(() => _isConfirming = false);

         if (success) {
              // Save to ReservationProvider for persistent storage
              try {
                final reservation = Reservation(
                  id: booking.id,
                  filmName: widget.movie.title,
                  sessionTime: selectedTime!,
                  salle: selectedRoom!.name,
                  seats: selectedSeats,
                  totalPrice: widget.movie.price * selectedSeats,
                  createdAt: DateTime.now(),
                  language: widget.movie.language,
                  moviePosterUrl: widget.movie.posterUrl,
                );
                if (mounted) {
                  await context.read<ReservationProvider>().addReservation(reservation);
                }
              } catch (e) {
                debugPrint('Error saving reservation: $e');
              }

              // Show feedback using the root scaffold messenger
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reservation confirmee pour ${widget.movie.title} !'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              }
           } else {
             _showErrorDialog('Erreur', 'Places insuffisantes ou erreur lors de la réservation');
           }
         }
      } catch (e) {
        if (mounted) {
          setState(() => _isConfirming = false);
          _showErrorDialog('Erreur', 'Une erreur est survenue: $e');
        }
      }
    }

   void _showErrorDialog(String title, String message) {
     showDialog(
       context: context,
       builder: (context) => AlertDialog(
         title: Text(title),
         content: Text(message),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context),
             child: const Text('OK'),
           ),
         ],
       ),
     );
   }
}
