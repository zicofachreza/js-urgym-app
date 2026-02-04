abstract class BookingDetailEvent {}

class LoadBookingDetail extends BookingDetailEvent {
  final String id;
  LoadBookingDetail(this.id);
}
