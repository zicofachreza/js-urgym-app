import 'package:client/core/extensions/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/membership_plan_bloc.dart';
import '../bloc/membership_plan_event.dart';
import '../bloc/membership_plan_state.dart';
import './membership_summary_page.dart';

class MembershipPlanPage extends StatefulWidget {
  const MembershipPlanPage({super.key});

  @override
  State<MembershipPlanPage> createState() => _MembershipPlanPageState();
}

class _MembershipPlanPageState extends State<MembershipPlanPage> {
  @override
  void initState() {
    super.initState();
    context.read<MembershipPlanBloc>().add(LoadMembershipPlans());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Choose Membership',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: BlocBuilder<MembershipPlanBloc, MembershipPlanState>(
        builder: (context, state) {
          if (state is MembershipPlanLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 172, 14, 3),
              ),
            );
          }

          if (state is MembershipPlanError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is MembershipPlanLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.plans.length,
                    itemBuilder: (context, index) {
                      final plan = state.plans[index];
                      final selected = state.selected?.id == plan.id;

                      return GestureDetector(
                        onTap: () {
                          context.read<MembershipPlanBloc>().add(
                            SelectMembershipPlan(plan),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? const Color.fromARGB(255, 172, 14, 3)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${plan.durationMonths} Months',
                                style: const TextStyle(color: Colors.white60),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                plan.discountPrice != null
                                    ? plan.discountPrice!.toRupiah()
                                    : plan.price.toRupiah(),
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (plan.discountPrice != null)
                                Text(
                                  plan.price.toRupiah(),
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Text(
                                plan.description,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // NEXT BUTTON (muncul hanya jika ada selected)
                if (state.selected != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MembershipSummaryPage(plan: state.selected!),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            172,
                            14,
                            3,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
