import '../repositories/gym_class_repository.dart';
import '../../data/models/gym_class_model.dart';

class GetGymClassesUseCase {
  final GymClassRepository repository;

  GetGymClassesUseCase(this.repository);

  Future<List<GymClassModel>> execute() {
    return repository.getGymClasses();
  }
}
