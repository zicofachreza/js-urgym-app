import 'package:client/features/profile/data/models/profile_model.dart';
import 'package:dio/dio.dart';

class ProfileRemoteDatasource {
  final Dio dio;

  ProfileRemoteDatasource(this.dio);

  Future<void> logout() async {
    await dio.post('/logout');
  }

  Future<ProfileModel> getMyProfile() async {
    final response = await dio.get('/users/me');
    final data = response.data['data'];
    return ProfileModel.fromJson(data);
  }
}
