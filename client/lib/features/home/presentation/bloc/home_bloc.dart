import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../domain/usecases/get_home_data_usecase.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeBloc(this.getHomeDataUseCase) : super(HomeInitial()) {
    on<LoadHome>(_onLoadHome);
  }

  Future<void> _onLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final data = await getHomeDataUseCase.execute();
      emit(HomeLoaded(data));
    } catch (e) {
      emit(HomeError('Failed to load home data'));
    }
  }
}
