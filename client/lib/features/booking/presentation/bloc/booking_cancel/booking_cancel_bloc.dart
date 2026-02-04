import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../domain/usecases/cancel_booking_usecase.dart';
import 'booking_cancel_event.dart';
import 'booking_cancel_state.dart';

class BookingCancelBloc extends Bloc<BookingCancelEvent, BookingCancelState> {
  final CancelBookingUseCase useCase;

  BookingCancelBloc(this.useCase) : super(BookingCancelInitial()) {
    on<SubmitCancelBooking>((event, emit) async {
      emit(BookingCancelLoading());
      try {
        final msg = await useCase.execute(event.bookingId);
        emit(BookingCancelSuccess(msg));
      } on DioException catch (e) {
        final msg = e.response?.data['message'];
        emit(BookingCancelError(msg));
      } catch (e) {
        emit(
          BookingCancelError(
            'Cancel booking class failed due to an unexpected error. Please try again.',
          ),
        );
      }
    });

    on<ResetCancelBooking>((event, emit) {
      emit(BookingCancelInitial());
    });
  }
}
