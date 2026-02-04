import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/membership_plan_model.dart';
import '../../../payment/presentation/bloc/payment_bloc.dart';
import '../../../payment/presentation/bloc/payment_event.dart';
import '../../../payment/presentation/bloc/payment_state.dart';
import '../../../payment/presentation/pages/payment_webview_page.dart';

class MembershipSummaryPage extends StatelessWidget {
  final MembershipPlanModel plan;

  MembershipSummaryPage({super.key, required this.plan});

  final _currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  Widget build(BuildContext context) {
    final int finalPrice = plan.discountPrice ?? plan.price;

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 172, 14, 3),
              ),
            ),
          );
        }

        if (state is PaymentSuccess) {
          Navigator.pop(context); // close loading dialog

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentWebViewPage(url: state.redirectUrl),
            ),
          );
        }

        if (state is PaymentError) {
          Navigator.pop(context); // close loading dialog

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Color.fromARGB(255, 172, 14, 3),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Summary',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ===== PLAN CARD =====
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${plan.durationMonths} Months Membership',
                      style: const TextStyle(color: Colors.white60),
                    ),
                    const Divider(color: Colors.white12, height: 24),
                    const Text(
                      'Benefits',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
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

              const SizedBox(height: 24),

              // ===== PRICE SUMMARY =====
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _priceRow('Price', _currency.format(plan.price)),
                    if (plan.discountPrice != null) ...[
                      const SizedBox(height: 8),
                      _priceRow(
                        'Discount',
                        '- ${_currency.format(plan.price - plan.discountPrice!)}',
                        valueColor: Colors.green,
                      ),
                    ],
                    const Divider(color: Colors.white12, height: 24),
                    _priceRow(
                      'Total',
                      _currency.format(finalPrice),
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ===== PROCEED BUTTON =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<PaymentBloc>().add(CreatePayment(plan.id));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 172, 14, 3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    bool isTotal = false,
    Color valueColor = Colors.white,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: isTotal ? 15 : 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
