import 'package:client/features/profile/domain/usecases/get_my_profile_usecase.dart';
import 'package:client/features/profile/presentation/bloc/profile_data/profile_data_event.dart';
import 'package:client/features/profile/presentation/bloc/profile_data/profile_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDataBloc extends Bloc<ProfileDataEvent, ProfileDataState> {
  final GetMyProfileUsecase useCase;

  ProfileDataBloc(this.useCase) : super(ProfileDataInitial()) {
    on<LoadProfileData>((event, emit) async {
      emit(ProfileDataLoading());
      try {
        final profile = await useCase.execute();
        emit(ProfileDataLoaded(profile));
      } catch (e) {
        emit(ProfileDataError('Failed to load user profile data.'));
      }
    });
  }
}
