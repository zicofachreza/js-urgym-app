import 'package:flutter_bloc/flutter_bloc.dart';
import 'membership_plan_event.dart';
import 'membership_plan_state.dart';
import '../../domain/usecases/get_membership_plans_usecase.dart';

class MembershipPlanBloc
    extends Bloc<MembershipPlanEvent, MembershipPlanState> {
  final GetMembershipPlansUseCase useCase;

  MembershipPlanBloc(this.useCase) : super(MembershipPlanInitial()) {
    on<LoadMembershipPlans>((event, emit) async {
      emit(MembershipPlanLoading());
      try {
        final plans = await useCase.execute();
        emit(MembershipPlanLoaded(plans));
      } catch (_) {
        emit(MembershipPlanError('Failed to load membership plans'));
      }
    });

    on<SelectMembershipPlan>((event, emit) {
      if (state is MembershipPlanLoaded) {
        final current = state as MembershipPlanLoaded;

        // Jika plan yang sama diklik → unselect
        if (current.selected?.id == event.plan.id) {
          emit(MembershipPlanLoaded(current.plans, selected: null));
        } else {
          emit(MembershipPlanLoaded(current.plans, selected: event.plan));
        }
      }
    });
  }
}
