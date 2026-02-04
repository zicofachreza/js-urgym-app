import '../../data/models/membership_plan_model.dart';

abstract class MembershipPlanState {}

class MembershipPlanInitial extends MembershipPlanState {}

class MembershipPlanLoading extends MembershipPlanState {}

class MembershipPlanLoaded extends MembershipPlanState {
  final List<MembershipPlanModel> plans;
  final MembershipPlanModel? selected;

  MembershipPlanLoaded(this.plans, {this.selected});
}

class MembershipPlanError extends MembershipPlanState {
  final String message;
  MembershipPlanError(this.message);
}
