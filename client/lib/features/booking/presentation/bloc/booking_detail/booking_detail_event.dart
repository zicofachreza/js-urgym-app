abstract class BookingDetailEvent {}

class LoadBookingDetail extends BookingDetailEvent {
  final String id;
  LoadBookingDetail(this.id);
}

class CancelAndReloadBooking extends BookingDetailEvent {
  final String id;
  CancelAndReloadBooking(this.id);
}
