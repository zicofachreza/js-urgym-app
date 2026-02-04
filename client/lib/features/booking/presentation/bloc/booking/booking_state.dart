abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final String message;
  BookingSuccess(this.message);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
