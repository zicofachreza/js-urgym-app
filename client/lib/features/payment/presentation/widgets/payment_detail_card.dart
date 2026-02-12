import 'package:client/core/extensions/date_extension.dart';
import 'package:client/core/extensions/num_extension.dart';
import 'package:client/features/payment/data/models/payment_model.dart';
import 'package:flutter/material.dart';

class PaymentDetailCard extends StatelessWidget {
  final PaymentModel payment;

  const PaymentDetailCard({super.key, required this.payment});

  Color _statusColor() {
    switch (payment.status.toLowerCase()) {
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
    return Column(
      children: [
        // ===== MAIN PAYMENT CARD =====
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                payment.membershipName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _infoRow('Duration', '${payment.durationMonths} Months'),
              _infoRow('Price', payment.amount.toRupiah()),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    payment.status.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ===== ORDER INFO CARD =====
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('Order ID', payment.midtransOrderId),
              _infoRow('Order At', payment.createdAt.toReadableDateTime()),
            ],
          ),
        ),
      ],
    );
  }

  // ===== SHARED CARD STYLE =====
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
