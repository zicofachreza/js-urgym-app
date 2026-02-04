import 'package:equatable/equatable.dart';

class BottomNavState extends Equatable {
  final int index;

  const BottomNavState(this.index);

  @override
  List<Object?> get props => [index];
}
