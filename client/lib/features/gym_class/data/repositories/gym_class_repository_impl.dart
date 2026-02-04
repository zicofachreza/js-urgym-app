import '../../domain/repositories/gym_class_repository.dart';
import '../datasources/gym_class_remote_datasource.dart';
import '../models/gym_class_model.dart';

class GymClassRepositoryImpl implements GymClassRepository {
  final GymClassRemoteDatasource remote;

  GymClassRepositoryImpl(this.remote);

  @override
  Future<List<GymClassModel>> getGymClasses() {
    return remote.fetchGymClasses();
  }

  @override
  Future<GymClassModel> getGymClassById(String id) {
    return remote.fetchGymClassById(id);
  }
}
