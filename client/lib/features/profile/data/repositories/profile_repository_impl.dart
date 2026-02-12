import 'package:client/features/profile/data/models/profile_model.dart';

import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<void> logout() {
    return remote.logout();
  }

  @override
  Future<ProfileModel> getMyProfile() {
    return remote.getMyProfile();
  }
}
