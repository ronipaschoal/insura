import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Gradient banner greeting the signed-in user, shown at the top of Home.
class HomeWelcomeBanner extends StatelessWidget {
  const HomeWelcomeBanner({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.loginGradientStart, AppColors.loginGradientEnd],
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bem-vindo',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                userName.isEmpty ? 'Usuário' : userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
