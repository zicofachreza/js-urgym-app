import 'package:client/core/extensions/date_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/dio_client.dart';

// ===== BLOC HISTORY =====
import '../bloc/booking_history/booking_history_bloc.dart';
import '../bloc/booking_history/booking_history_event.dart';
import '../bloc/booking_history/booking_history_state.dart';

// ===== BOOKING DETAIL =====
import '../../data/models/booking_model.dart';
import '../pages/booking_detail_page.dart';
import '../bloc/booking_detail/booking_detail_bloc.dart';
import '../../domain/usecases/get_booking_by_id_usecase.dart';
import '../../data/datasources/booking_remote_datasource.dart';
import '../../data/repositories/booking_repository_impl.dart';

// ===== BOOKING CANCEL =====
import '../bloc/booking_cancel/booking_cancel_bloc.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingHistoryBloc>().add(LoadBookingHistory());
  }

  // ================== STATUS COLOR ==================
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  // ================== ICON BY CLASS ==================
  IconData _getIconByClassName(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('boxing')) return Icons.sports_mma;
    if (lower.contains('yoga')) return Icons.self_improvement;
    if (lower.contains('cardio')) return Icons.directions_run;
    if (lower.contains('zumba')) return Icons.music_note;
    if (lower.contains('crossfit')) return Icons.fitness_center;
    if (lower.contains('pilates')) return Icons.accessibility_new;

    return Icons.fitness_center;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Booking History',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocBuilder<BookingHistoryBloc, BookingHistoryState>(
        builder: (context, state) {
          // ⏳ LOADING
          if (state is BookingHistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 172, 14, 3),
              ),
            );
          }

          // ❌ ERROR
          if (state is BookingHistoryError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Color.fromARGB(255, 172, 14, 3)),
              ),
            );
          }

          // ✅ LOADED
          if (state is BookingHistoryLoaded) {
            if (state.bookings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.history, size: 72, color: Colors.white38),
                    SizedBox(height: 12),
                    Text(
                      'No bookings yet',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your booking history will appear here',
                      style: TextStyle(color: Colors.white38, fontSize: 13),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final BookingModel booking = state.bookings[index];

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          final dio = DioClient.create();

                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) {
                                  final repository = BookingRepositoryImpl(
                                    BookingRemoteDatasource(dio),
                                  );

                                  return BookingDetailBloc(
                                    GetBookingByIdUseCase(repository),
                                    CancelBookingUseCase(repository),
                                  );
                                },
                              ),
                              BlocProvider(
                                create: (_) => BookingCancelBloc(
                                  CancelBookingUseCase(
                                    BookingRepositoryImpl(
                                      BookingRemoteDatasource(dio),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            child: BookingDetailPage(bookingId: booking.id),
                          );
                        },
                      ),
                    );

                    if (!context.mounted) return;

                    context.read<BookingHistoryBloc>().add(
                      LoadBookingHistory(),
                    );
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ICON
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(
                              255,
                              172,
                              14,
                              3,
                            ).withValues(alpha: 0.15),
                          ),
                          child: Icon(
                            _getIconByClassName(booking.className),
                            color: const Color.fromARGB(255, 172, 14, 3),
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // CLASS NAME
                              Text(
                                booking.className,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // SCHEDULE
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 14,
                                    color: Colors.white60,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    booking.schedule.toReadableDateTime(),
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // STATUS
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _statusColor(booking.status),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    booking.status.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
