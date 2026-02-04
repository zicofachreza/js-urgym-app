import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// ===== BOOKING DETAIL =====
import '../bloc/booking_detail/booking_detail_bloc.dart';
import '../bloc/booking_detail/booking_detail_event.dart';
import '../bloc/booking_detail/booking_detail_state.dart';

// ===== CANCEL BOOKING =====
import '../bloc/booking_cancel/booking_cancel_bloc.dart';
import '../bloc/booking_cancel/booking_cancel_event.dart';
import '../bloc/booking_cancel/booking_cancel_state.dart';

class BookingDetailPage extends StatefulWidget {
  final String bookingId;

  const BookingDetailPage({super.key, required this.bookingId});

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingDetailBloc>().add(LoadBookingDetail(widget.bookingId));
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  void _showCancelConfirmationDialog(String bookingId) {
    final bookingCancelBloc = context.read<BookingCancelBloc>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return BlocProvider.value(
          value: bookingCancelBloc,
          child: AlertDialog(
            backgroundColor: Colors.grey.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: const [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color.fromARGB(255, 172, 14, 3),
                ),
                SizedBox(width: 8),
                Text('Cancel Booking', style: TextStyle(color: Colors.white)),
              ],
            ),
            content: const Text(
              'Are you sure you want to cancel this booking?\n\n'
              'This action cannot be undone.',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              BlocBuilder<BookingCancelBloc, BookingCancelState>(
                builder: (context, cancelState) {
                  final isLoading = cancelState is BookingCancelLoading;

                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                            context.read<BookingCancelBloc>().add(
                              SubmitCancelBooking(bookingId),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 172, 14, 3),
                      disabledBackgroundColor: const Color.fromARGB(
                        255,
                        172,
                        14,
                        3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Yes, Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<BookingDetailBloc, BookingDetailState>(
        builder: (context, state) {
          if (state is BookingDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 172, 14, 3),
              ),
            );
          }

          if (state is BookingDetailError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Color.fromARGB(255, 172, 14, 3)),
              ),
            );
          }

          if (state is BookingDetailLoaded) {
            final booking = state.booking;
            final bool isCancelled = booking.status == 'cancelled';

            return Column(
              children: [
                // ===== CONTENT =====
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.className,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(booking.status),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            booking.status.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _infoRow(
                                Icons.schedule,
                                'Booking At',
                                DateFormat(
                                  'EEE, dd MMM yyyy • HH:mm',
                                ).format(booking.bookingDate.toLocal()),
                              ),
                              const SizedBox(height: 12),
                              _infoRow(
                                Icons.cancel,
                                'Cancelled At',
                                booking.cancelledAt == null
                                    ? '-'
                                    : DateFormat(
                                        'EEE, dd MMM yyyy • HH:mm',
                                      ).format(booking.cancelledAt!.toLocal()),
                              ),
                              const SizedBox(height: 12),
                              _infoRow(
                                Icons.person,
                                'Instructor',
                                booking.instructor,
                              ),
                              const SizedBox(height: 12),
                              _infoRow(
                                Icons.timer,
                                'Duration',
                                '${booking.duration} minutes',
                              ),
                              const SizedBox(height: 12),
                              _infoRow(
                                Icons.people,
                                'Slots',
                                '${booking.capacity}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ===== BOTTOM BUTTON =====
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: BlocConsumer<BookingCancelBloc, BookingCancelState>(
                    listener: (context, cancelState) {
                      if (cancelState is BookingCancelError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(cancelState.message),
                            backgroundColor: const Color.fromARGB(
                              255,
                              172,
                              14,
                              3,
                            ),
                          ),
                        );
                      }

                      if (cancelState is BookingCancelSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(cancelState.message),
                            backgroundColor: Colors.green,
                          ),
                        );

                        context.read<BookingCancelBloc>().add(
                          ResetCancelBooking(),
                        );

                        context.read<BookingDetailBloc>().add(
                          LoadBookingDetail(widget.bookingId),
                        );
                      }
                    },
                    builder: (context, cancelState) {
                      final bool isLoading =
                          cancelState is BookingCancelLoading;

                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isCancelled || isLoading
                              ? null
                              : () {
                                  _showCancelConfirmationDialog(booking.id);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              172,
                              14,
                              3,
                            ),
                            disabledBackgroundColor: Colors.grey.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            isCancelled
                                ? 'Booking Cancelled'
                                : 'Cancel Booking',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white60),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.white60)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
