import 'package:dio/dio.dart';
import '../models/gym_class_model.dart';

class GymClassRemoteDatasource {
  final Dio dio;

  GymClassRemoteDatasource(this.dio);

  Future<List<GymClassModel>> fetchGymClasses() async {
    final response = await dio.get('/gym-classes');

    return (response.data['data'] as List)
        .map((e) => GymClassModel.fromJson(e))
        .toList();
  }

  Future<GymClassModel> fetchGymClassById(String id) async {
    final response = await dio.get('/gym-classes/$id');

    return GymClassModel.fromJson(response.data['data']);
  }
}
