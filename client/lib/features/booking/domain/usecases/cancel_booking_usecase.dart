import 'package:client/features/booking/domain/repositories/booking_repository.dart';

class CancelBookingUseCase {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<String> execute(String bookingId) {
    return repository.cancelBookClass(bookingId);
  }
}
