import 'package:dio/dio.dart';
import '../models/membership_plan_model.dart';

class MembershipPlanRemoteDatasource {
  final Dio dio;

  MembershipPlanRemoteDatasource(this.dio);

  Future<List<MembershipPlanModel>> fetchPlans() async {
    final response = await dio.get('/membership-plans');

    return (response.data['data'] as List)
        .map((e) => MembershipPlanModel.fromJson(e))
        .toList();
  }
}
