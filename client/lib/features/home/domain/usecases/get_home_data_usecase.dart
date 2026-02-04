import '../repositories/home_repository.dart';
import '../../data/models/home_model.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);

  Future<HomeData> execute() {
    return repository.getHomeData();
  }
}
