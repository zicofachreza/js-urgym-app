import '../../domain/repositories/membership_plan_repository.dart';
import '../datasources/membership_plan_remote_datasource.dart';
import '../models/membership_plan_model.dart';

class MembershipPlanRepositoryImpl implements MembershipPlanRepository {
  final MembershipPlanRemoteDatasource remote;

  MembershipPlanRepositoryImpl(this.remote);

  @override
  Future<List<MembershipPlanModel>> getPlans() {
    return remote.fetchPlans();
  }
}
