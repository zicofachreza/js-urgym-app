import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class MembershipBarcodePage extends StatelessWidget {
  final String username;
  final String barcodeToken;
  final DateTime? expiredAt;

  const MembershipBarcodePage({
    super.key,
    required this.username,
    required this.barcodeToken,
    this.expiredAt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Membership Barcode',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // ===== MEMBER NAME =====
            Text(
              username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              expiredAt != null
                  ? 'Valid until ${_formatDate(expiredAt!)}'
                  : 'Active Membership',
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),

            const SizedBox(height: 40),

            // ===== BARCODE CARD =====
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color.fromARGB(255, 172, 14, 3), Colors.black],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: barcodeToken,
                      width: double.infinity,
                      height: 90,
                      drawText: false,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      barcodeToken,
                      style: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ===== INFO =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color.fromARGB(255, 172, 14, 3),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Scan this barcode to the receptionist to access the gym.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ===== SECURITY NOTE =====
            const Text(
              'This barcode refreshes automatically for security.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
