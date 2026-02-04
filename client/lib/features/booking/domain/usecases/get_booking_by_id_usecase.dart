import '../repositories/booking_repository.dart';
import '../../data/models/booking_model.dart';

class GetBookingByIdUseCase {
  final BookingRepository repository;

  GetBookingByIdUseCase(this.repository);

  Future<BookingModel> execute(String id) {
    return repository.getBookingById(id);
  }
}
