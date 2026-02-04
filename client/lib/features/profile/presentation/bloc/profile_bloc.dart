import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/token_storage.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../domain/usecases/logout_usecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final LogoutUseCase logoutUseCase;
  final TokenStorage tokenStorage;

  ProfileBloc(this.logoutUseCase, this.tokenStorage) : super(ProfileInitial()) {
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await logoutUseCase.execute();
      await tokenStorage.clear();
      emit(LogoutSuccess());
    } catch (e) {
      emit(ProfileError('Logout failed'));
    }
  }
}
