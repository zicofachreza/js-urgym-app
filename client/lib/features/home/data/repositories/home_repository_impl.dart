import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/home_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource remote;

  HomeRepositoryImpl(this.remote);

  @override
  Future<HomeData> getHomeData() {
    return remote.fetchHome();
  }
}
