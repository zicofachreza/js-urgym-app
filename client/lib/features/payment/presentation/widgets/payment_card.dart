import 'package:flutter/material.dart';
import 'package:client/features/payment/data/models/payment_model.dart';
import 'package:client/core/extensions/num_extension.dart';
import 'payment_info_row.dart';

class PaymentCard extends StatelessWidget {
  final PaymentModel payment;
  final VoidCallback? onTap;

  const PaymentCard({super.key, required this.payment, this.onTap});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'success':
        return Colors.greenAccent;
      case 'pending':
        return Colors.orangeAccent;
      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    payment.membershipName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(
                        payment.status,
                      ).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      payment.status.toUpperCase(),
                      style: TextStyle(
                        color: _statusColor(payment.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              PaymentInfoRow(
                label: 'Duration',
                value: '${payment.durationMonths} Months',
              ),
              PaymentInfoRow(label: 'Price', value: payment.amount.toRupiah()),
            ],
          ),
        ),
      ),
    );
  }
}
