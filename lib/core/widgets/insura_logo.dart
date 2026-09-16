import 'package:flutter/material.dart';

class InsuraLogo extends StatelessWidget {
  const InsuraLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.shield_outlined, color: Colors.white, size: 22),
        SizedBox(width: 8),
        Text(
          'INSURA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.4,
          ),
        ),
      ],
    );
  }
}
