import 'package:flutter_bloc/flutter_bloc.dart';
import 'gym_class_event.dart';
import 'gym_class_state.dart';
import '../../../domain/usecases/get_gym_class_list_usecase.dart';

class GymClassBloc extends Bloc<GymClassEvent, GymClassState> {
  final GetGymClassesUseCase useCase;

  GymClassBloc(this.useCase) : super(GymClassInitial()) {
    on<LoadGymClasses>((event, emit) async {
      emit(GymClassLoading());
      try {
        final data = await useCase.execute();
        emit(GymClassLoaded(data));
      } catch (_) {
        emit(GymClassError('Failed to load gym classes.'));
      }
    });
  }
}
