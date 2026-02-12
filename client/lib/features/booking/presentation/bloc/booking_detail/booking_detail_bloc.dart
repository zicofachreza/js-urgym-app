import 'package:client/features/booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:client/features/booking/domain/usecases/get_booking_by_id_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_detail_event.dart';
import 'booking_detail_state.dart';

class BookingDetailBloc extends Bloc<BookingDetailEvent, BookingDetailState> {
  final GetBookingByIdUseCase getBookingUsecase;
  final CancelBookingUseCase cancelBookingUseCase;

  BookingDetailBloc(this.getBookingUsecase, this.cancelBookingUseCase)
    : super(BookingDetailLoading()) {
    on<LoadBookingDetail>(_onLoadBookingDetail);
    on<CancelAndReloadBooking>(_onCancelAndReloadBooking);
  }

  Future<void> _onLoadBookingDetail(
    LoadBookingDetail event,
    Emitter<BookingDetailState> emit,
  ) async {
    emit(BookingDetailLoading());

    try {
      final booking = await getBookingUsecase.execute(event.id);
      emit(BookingDetailLoaded(booking));
    } catch (e) {
      emit(BookingDetailError('Failed to load booking detail'));
    }
  }

  Future<void> _onCancelAndReloadBooking(
    CancelAndReloadBooking event,
    Emitter<BookingDetailState> emit,
  ) async {
    emit(BookingDetailLoading());

    try {
      final msg = await cancelBookingUseCase.execute(event.id);
      emit(BookingDetailCancelSuccess(msg));

      final booking = await getBookingUsecase.execute(event.id);
      emit(BookingDetailLoaded(booking));
    } catch (e) {
      emit(BookingDetailError('Failed to cancel payment'));
    }
  }
}
