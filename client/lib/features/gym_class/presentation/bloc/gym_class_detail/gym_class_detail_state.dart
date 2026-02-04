import '../../../data/models/gym_class_model.dart';

abstract class GymClassDetailState {}

class GymClassDetailInitial extends GymClassDetailState {}

class GymClassDetailLoading extends GymClassDetailState {}

class GymClassDetailLoaded extends GymClassDetailState {
  final GymClassModel gymClass;
  GymClassDetailLoaded(this.gymClass);
}

class GymClassDetailError extends GymClassDetailState {
  final String message;
  GymClassDetailError(this.message);
}
