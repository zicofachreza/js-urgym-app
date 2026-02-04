import '../repositories/gym_class_repository.dart';
import '../../data/models/gym_class_model.dart';

class GetGymClassDetailUseCase {
  final GymClassRepository repository;

  GetGymClassDetailUseCase(this.repository);

  Future<GymClassModel> execute(String id) {
    return repository.getGymClassById(id);
  }
}
