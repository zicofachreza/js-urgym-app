import 'package:client/features/profile/data/models/profile_model.dart';
import 'package:client/features/profile/domain/repositories/profile_repository.dart';

class GetMyProfileUsecase {
  final ProfileRepository repository;

  GetMyProfileUsecase(this.repository);

  Future<ProfileModel> execute() {
    return repository.getMyProfile();
  }
}
