import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../../../core/storage/token_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final TokenStorage tokenStorage;

  AuthBloc(this.loginUseCase, this.registerUseCase, this.tokenStorage)
    : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await loginUseCase.execute(event.email, event.password);
      await tokenStorage.save(token);
      emit(AuthAuthenticated());
    } on DioException catch (e) {
      final msg = e.response?.data['message'];
      emit(AuthError(msg));
    } catch (e) {
      emit(AuthError('Login failed. Please try again.'));
    }
  }

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await registerUseCase.execute(
        event.username,
        event.email,
        event.password,
      );
      emit(AuthRegistered());
    } on DioException catch (e) {
      final msg = e.response?.data['message'];
      emit(AuthError(msg));
    } catch (e) {
      emit(AuthError('Registration failed. Please try again.'));
    }
  }
}
