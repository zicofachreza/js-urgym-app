import '../../data/models/membership_plan_model.dart';

abstract class MembershipPlanRepository {
  Future<List<MembershipPlanModel>> getPlans();
}
