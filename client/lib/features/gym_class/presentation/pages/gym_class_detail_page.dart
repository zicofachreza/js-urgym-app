import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// ===== GYM CLASS DETAIL =====
import '../bloc/gym_class_detail/gym_class_detail_bloc.dart';
import '../bloc/gym_class_detail/gym_class_detail_event.dart';
import '../bloc/gym_class_detail/gym_class_detail_state.dart';

// ===== BOOKING =====
import '../../../booking/presentation/bloc/booking/booking_bloc.dart';
import '../../../booking/presentation/bloc/booking/booking_event.dart';
import '../../../booking/presentation/bloc/booking/booking_state.dart';

class GymClassDetailPage extends StatefulWidget {
  final String classId;

  const GymClassDetailPage({super.key, required this.classId});

  @override
  State<GymClassDetailPage> createState() => _GymClassDetailPageState();
}

class _GymClassDetailPageState extends State<GymClassDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<GymClassDetailBloc>().add(LoadGymClassDetail(widget.classId));
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
      body: BlocBuilder<GymClassDetailBloc, GymClassDetailState>(
        builder: (context, state) {
          // ===== LOADING =====
          if (state is GymClassDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 172, 14, 3),
              ),
            );
          }

          // ===== ERROR =====
          if (state is GymClassDetailError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Color.fromARGB(255, 172, 14, 3)),
              ),
            );
          }

          // ===== LOADED =====
          if (state is GymClassDetailLoaded) {
            final item = state.gymClass;

            final bool isAvailable = item.availableSlots > 0;
            final bool isBooked = item.status == 'confirmed';

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
                          item.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // INFO CARD
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
                                'Schedule',
                                DateFormat(
                                  'EEE, dd MMM yyyy • HH:mm',
                                ).format(item.schedule.toLocal()),
                              ),
                              const SizedBox(height: 12),
                              _infoRow(
                                Icons.person,
                                'Instructor',
                                item.instructor,
                              ),
                              const SizedBox(height: 12),
                              _infoRow(
                                Icons.timer,
                                'Duration',
                                '${item.duration} minutes',
                              ),
                              const SizedBox(height: 12),
                              _infoRow(
                                Icons.people,
                                'Slots',
                                '${item.availableSlots} / ${item.capacity}',
                                valueColor: isAvailable
                                    ? Colors.green
                                    : const Color.fromARGB(255, 172, 14, 3),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ===== BOOK BUTTON =====
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: BlocConsumer<BookingBloc, BookingState>(
                    listener: (context, bookingState) {
                      if (bookingState is BookingError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(bookingState.message),
                            backgroundColor: const Color.fromARGB(
                              255,
                              172,
                              14,
                              3,
                            ),
                          ),
                        );
                      }

                      if (bookingState is BookingSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(bookingState.message),
                            backgroundColor: Colors.green,
                          ),
                        );

                        context.read<BookingBloc>().add(ResetBooking());

                        context.read<GymClassDetailBloc>().add(
                          LoadGymClassDetail(widget.classId),
                        );
                      }
                    },
                    builder: (context, bookingState) {
                      final bool isLoading = bookingState is BookingLoading;

                      // ❗ disable HANYA jika booked / slot habis
                      final bool isDisabled = !isAvailable || isBooked;

                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isDisabled
                              ? null
                              : () {
                                  if (!isLoading) {
                                    context.read<BookingBloc>().add(
                                      SubmitBooking(item.id),
                                    );
                                  }
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
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  isBooked ? 'Booked' : 'Book Now',
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

  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    Color valueColor = Colors.white,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white60),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.white60)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(color: valueColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
