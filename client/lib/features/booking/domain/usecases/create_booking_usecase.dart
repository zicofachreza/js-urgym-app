import '../repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<String> execute(String classId) {
    return repository.bookClass(classId);
  }
}
