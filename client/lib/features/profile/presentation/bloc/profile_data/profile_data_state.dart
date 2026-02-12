import 'package:client/features/profile/data/models/profile_model.dart';

abstract class ProfileDataState {}

class ProfileDataInitial extends ProfileDataState {}

class ProfileDataLoading extends ProfileDataState {}

class ProfileDataLoaded extends ProfileDataState {
  final ProfileModel profile;
  ProfileDataLoaded(this.profile);
}

class ProfileDataError extends ProfileDataState {
  final String message;
  ProfileDataError(this.message);
}
