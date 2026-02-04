import 'package:client/features/booking/data/models/booking_model.dart';
import 'package:dio/dio.dart';

class BookingRemoteDatasource {
  final Dio dio;

  BookingRemoteDatasource(this.dio);

  Future<String> bookClass(String classId) async {
    final response = await dio.post('/gym-classes/$classId/book');

    return response.data['message'];
  }

  Future<String> cancelBookClass(String bookingId) async {
    final response = await dio.post('/bookings/$bookingId/cancel');

    return response.data['message'];
  }

  Future<List<BookingModel>> getMyBookings() async {
    final response = await dio.get('/bookings/me');

    final List data = response.data['data'];

    return data.map((e) => BookingModel.fromJson(e)).toList();
  }

  Future<BookingModel> fetchBookingById(String id) async {
    final response = await dio.get('/bookings/$id');
    return BookingModel.fromJson(response.data['data']);
  }
}
