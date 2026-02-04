abstract class GymClassDetailEvent {}

class LoadGymClassDetail extends GymClassDetailEvent {
  final String id;
  LoadGymClassDetail(this.id);
}
