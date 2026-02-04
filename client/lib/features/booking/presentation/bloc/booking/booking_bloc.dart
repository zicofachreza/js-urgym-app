import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../domain/usecases/create_booking_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUseCase useCase;

  BookingBloc(this.useCase) : super(BookingInitial()) {
    on<SubmitBooking>((event, emit) async {
      emit(BookingLoading());
      try {
        final msg = await useCase.execute(event.classId);
        emit(BookingSuccess(msg));
      } on DioException catch (e) {
        final msg = e.response?.data['message'];
        emit(BookingError(msg));
      } catch (e) {
        emit(
          BookingError(
            'Booking class failed due to an unexpected error. Please try again.',
          ),
        );
      }
    });

    on<ResetBooking>((event, emit) {
      emit(BookingInitial());
    });
  }
}
