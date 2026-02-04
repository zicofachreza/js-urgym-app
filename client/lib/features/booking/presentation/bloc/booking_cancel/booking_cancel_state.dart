abstract class BookingCancelState {}

class BookingCancelInitial extends BookingCancelState {}

class BookingCancelLoading extends BookingCancelState {}

class BookingCancelSuccess extends BookingCancelState {
  final String message;
  BookingCancelSuccess(this.message);
}

class BookingCancelError extends BookingCancelState {
  final String message;
  BookingCancelError(this.message);
}
