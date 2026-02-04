import 'package:flutter_bloc/flutter_bloc.dart';
import 'gym_class_detail_event.dart';
import 'gym_class_detail_state.dart';
import '../../../domain/usecases/get_gym_class_detail_usecase.dart';

class GymClassDetailBloc
    extends Bloc<GymClassDetailEvent, GymClassDetailState> {
  final GetGymClassDetailUseCase useCase;

  GymClassDetailBloc(this.useCase) : super(GymClassDetailInitial()) {
    on<LoadGymClassDetail>((event, emit) async {
      emit(GymClassDetailLoading());
      try {
        final data = await useCase.execute(event.id);
        emit(GymClassDetailLoaded(data));
      } catch (_) {
        emit(GymClassDetailError('Failed to load class detail'));
      }
    });
  }
}
