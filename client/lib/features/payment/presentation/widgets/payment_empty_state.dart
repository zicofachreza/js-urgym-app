import 'package:flutter/material.dart';

class PaymentEmptyState extends StatelessWidget {
  const PaymentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.receipt_long, size: 72, color: Colors.white38),
          SizedBox(height: 12),
          Text(
            'No transactions yet',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Your payment history will appear here',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
