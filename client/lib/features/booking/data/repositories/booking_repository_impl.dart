import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDatasource remote;

  BookingRepositoryImpl(this.remote);

  @override
  Future<String> bookClass(String classId) {
    return remote.bookClass(classId);
  }

  @override
  Future<String> cancelBookClass(String bookingId) {
    return remote.cancelBookClass(bookingId);
  }

  @override
  Future<List<BookingModel>> getMyBookings() {
    return remote.getMyBookings();
  }

  @override
  Future<BookingModel> getBookingById(String id) {
    return remote.fetchBookingById(id);
  }
}
