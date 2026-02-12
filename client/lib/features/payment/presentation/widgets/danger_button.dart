import 'package:flutter/material.dart';

class DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const DangerButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color.fromARGB(255, 172, 14, 3)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 172, 14, 3),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
