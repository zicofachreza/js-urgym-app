import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_history_event.dart';
import 'booking_history_state.dart';
import '../../../domain/usecases/get_my_booking_usecase.dart';

class BookingHistoryBloc
    extends Bloc<BookingHistoryEvent, BookingHistoryState> {
  final GetMyBookingsUseCase useCase;

  BookingHistoryBloc(this.useCase) : super(BookingHistoryInitial()) {
    on<LoadBookingHistory>((event, emit) async {
      emit(BookingHistoryLoading());
      try {
        final bookings = await useCase.execute();
        emit(BookingHistoryLoaded(bookings));
      } catch (e) {
        emit(BookingHistoryError('Failed to load booking history.'));
      }
    });
  }
}
