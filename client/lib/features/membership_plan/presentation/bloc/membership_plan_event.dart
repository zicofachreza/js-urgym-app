import '../../data/models/membership_plan_model.dart';

abstract class MembershipPlanEvent {}

class LoadMembershipPlans extends MembershipPlanEvent {}

class SelectMembershipPlan extends MembershipPlanEvent {
  final MembershipPlanModel plan;
  SelectMembershipPlan(this.plan);
}
