import '../../../data/models/gym_class_model.dart';

abstract class GymClassState {}

class GymClassInitial extends GymClassState {}

class GymClassLoading extends GymClassState {}

class GymClassLoaded extends GymClassState {
  final List<GymClassModel> classes;
  GymClassLoaded(this.classes);
}

class GymClassError extends GymClassState {
  final String message;
  GymClassError(this.message);
}
