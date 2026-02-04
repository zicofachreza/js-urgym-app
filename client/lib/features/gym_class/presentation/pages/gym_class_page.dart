import '../../../../core/network/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/gym_class/gym_class_bloc.dart';
import '../bloc/gym_class/gym_class_event.dart';
import '../bloc/gym_class/gym_class_state.dart';
import '../../data/models/gym_class_model.dart';
import '../../data/datasources/gym_class_remote_datasource.dart';
import '../../data/repositories/gym_class_repository_impl.dart';

import '../pages/gym_class_detail_page.dart';
import '../bloc/gym_class_detail/gym_class_detail_bloc.dart';
import '../../domain/usecases/get_gym_class_detail_usecase.dart';

import '../../../booking/presentation/bloc/booking/booking_bloc.dart';
import '../../../booking/domain/usecases/create_booking_usecase.dart';
import '../../../booking/data/datasources/booking_remote_datasource.dart';
import '../../../booking/data/repositories/booking_repository_impl.dart';

class GymClassPage extends StatefulWidget {
  const GymClassPage({super.key});

  @override
  State<GymClassPage> createState() => _GymClassPageState();
}

class _GymClassPageState extends State<GymClassPage> {
  @override
  void initState() {
    super.initState();
    context.read<GymClassBloc>().add(LoadGymClasses());
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date.toLocal());
  }

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
          'Gym Classes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocBuilder<GymClassBloc, GymClassState>(
        builder: (context, state) {
          // ⏳ LOADING
          if (state is GymClassLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 172, 14, 3),
                strokeWidth: 3,
              ),
            );
          }

          // ❌ ERROR
          if (state is GymClassError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Color.fromARGB(255, 172, 14, 3)),
              ),
            );
          }

          // ✅ LOADED
          if (state is GymClassLoaded) {
            if (state.classes.isEmpty) {
              return const Center(
                child: Text(
                  'No gym classes available',
                  style: TextStyle(color: Colors.white60),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.classes.length,
              itemBuilder: (context, index) {
                final GymClassModel item = state.classes[index];
                final bool isAvailable = item.availableSlots > 0;

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
                                create: (_) => GymClassDetailBloc(
                                  GetGymClassDetailUseCase(
                                    GymClassRepositoryImpl(
                                      GymClassRemoteDatasource(dio),
                                    ),
                                  ),
                                ),
                              ),
                              BlocProvider(
                                create: (_) => BookingBloc(
                                  CreateBookingUseCase(
                                    BookingRepositoryImpl(
                                      BookingRemoteDatasource(dio),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            child: GymClassDetailPage(classId: item.id),
                          );
                        },
                      ),
                    );

                    if (!context.mounted) return;

                    context.read<GymClassBloc>().add(LoadGymClasses());
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
                            _getIconByClassName(item.name),
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
                              Text(
                                item.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 14,
                                    color: Colors.white60,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _formatTime(item.schedule),
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // SLOT
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${item.availableSlots} slots',
                              style: TextStyle(
                                color: isAvailable
                                    ? Colors.green
                                    : Color.fromARGB(255, 172, 14, 3),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isAvailable ? 'Available' : 'Full',
                              style: TextStyle(
                                color: isAvailable
                                    ? Colors.green
                                    : Color.fromARGB(255, 172, 14, 3),
                                fontSize: 12,
                              ),
                            ),
                          ],
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
