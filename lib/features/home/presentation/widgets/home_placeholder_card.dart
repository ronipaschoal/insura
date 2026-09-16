import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Empty-state card used by the "Minha Família" and "Contratados" sections.
class HomePlaceholderCard extends StatelessWidget {
  const HomePlaceholderCard({
    super.key,
    required this.icon,
    required this.message,
    this.onTap,
  });

  final IconData icon;
  final String message;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.homeSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.white54),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
