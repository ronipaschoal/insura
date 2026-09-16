import 'package:flutter/material.dart';

import '../../../../core/widgets/insura_logo.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        InsuraLogo(),
        SizedBox(height: 16),
        Text(
          'Bem vindo!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Aqui você gerencia seus seguros e de seus familiares em poucos '
          'cliques!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}
