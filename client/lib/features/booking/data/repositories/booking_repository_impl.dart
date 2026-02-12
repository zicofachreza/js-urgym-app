import 'package:client/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:client/features/booking/data/models/booking_model.dart';
import 'package:client/features/booking/domain/repositories/booking_repository.dart';

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
