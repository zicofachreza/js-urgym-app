import 'package:client/features/profile/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<void> logout();
  Future<ProfileModel> getMyProfile();
}
