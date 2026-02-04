import '../../data/models/gym_class_model.dart';

abstract class GymClassRepository {
  Future<List<GymClassModel>> getGymClasses();
  Future<GymClassModel> getGymClassById(String id);
}
