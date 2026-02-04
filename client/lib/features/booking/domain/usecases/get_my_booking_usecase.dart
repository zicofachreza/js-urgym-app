import '../repositories/booking_repository.dart';
import '../../data/models/booking_model.dart';

class GetMyBookingsUseCase {
  final BookingRepository repository;

  GetMyBookingsUseCase(this.repository);

  Future<List<BookingModel>> execute() {
    return repository.getMyBookings();
  }
}
