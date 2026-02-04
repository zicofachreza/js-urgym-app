abstract class BookingEvent {}

class SubmitBooking extends BookingEvent {
  final String classId;
  SubmitBooking(this.classId);
}

class ResetBooking extends BookingEvent {}
