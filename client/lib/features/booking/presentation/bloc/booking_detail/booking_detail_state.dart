import '../../../data/models/booking_model.dart';

abstract class BookingDetailState {}

class BookingDetailInitial extends BookingDetailState {}

class BookingDetailLoading extends BookingDetailState {}

class BookingDetailLoaded extends BookingDetailState {
  final BookingModel booking;
  BookingDetailLoaded(this.booking);
}

class BookingDetailError extends BookingDetailState {
  final String message;
  BookingDetailError(this.message);
}
