import '../repositories/membership_plan_repository.dart';
import '../../data/models/membership_plan_model.dart';

class GetMembershipPlansUseCase {
  final MembershipPlanRepository repository;

  GetMembershipPlansUseCase(this.repository);

  Future<List<MembershipPlanModel>> execute() {
    return repository.getPlans();
  }
}
