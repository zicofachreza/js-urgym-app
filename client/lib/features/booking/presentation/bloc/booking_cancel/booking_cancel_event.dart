abstract class BookingCancelEvent {}

class SubmitCancelBooking extends BookingCancelEvent {
  final String bookingId;
  SubmitCancelBooking(this.bookingId);
}

class ResetCancelBooking extends BookingCancelEvent {}
