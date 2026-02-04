import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_detail_event.dart';
import 'booking_detail_state.dart';
import '../../../domain/usecases/get_booking_by_id_usecase.dart';

class BookingDetailBloc extends Bloc<BookingDetailEvent, BookingDetailState> {
  final GetBookingByIdUseCase useCase;

  BookingDetailBloc(this.useCase) : super(BookingDetailLoading()) {
    on<LoadBookingDetail>((event, emit) async {
      emit(BookingDetailLoading());
      try {
        final booking = await useCase.execute(event.id);
        emit(BookingDetailLoaded(booking));
      } catch (e) {
        emit(BookingDetailError('Failed to load booking detail'));
      }
    });
  }
}
