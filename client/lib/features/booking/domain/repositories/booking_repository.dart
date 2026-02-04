import '../../data/models/booking_model.dart';

abstract class BookingRepository {
  Future<String> bookClass(String classId);
  Future<String> cancelBookClass(String bookingId);
  Future<List<BookingModel>> getMyBookings();
  Future<BookingModel> getBookingById(String id);
}
