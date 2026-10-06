import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'home_webview_target.dart';

class HomeQuoteCategory implements HomeWebViewTarget {
  const HomeQuoteCategory({
    required this.id,
    required this.icon,
    required this.label,
  });

  @override
  final String id;
  @override
  final IconData icon;
  @override
  final String label;
}

/// "Cotar e Contratar" categories shown as an icon grid on Home.
const List<HomeQuoteCategory> homeQuoteCategories = [
  HomeQuoteCategory(
    id: 'auto',
    icon: Icons.directions_car_outlined,
    label: 'Automóvel',
  ),
  HomeQuoteCategory(
    id: 'residencia',
    icon: Icons.storefront_outlined,
    label: 'Residência',
  ),
  HomeQuoteCategory(id: 'vida', icon: Icons.favorite_outline, label: 'Vida'),
  HomeQuoteCategory(
    id: 'acidentes-pessoais',
    icon: Icons.vaccines_outlined,
    label: 'Acidentes Pessoais',
  ),
  HomeQuoteCategory(
    id: 'moto',
    icon: Icons.two_wheeler_outlined,
    label: 'Moto',
  ),
  HomeQuoteCategory(
    id: 'empresa',
    icon: Icons.business_outlined,
    label: 'Empresa',
  ),
];

class HomeQuoteCategories extends StatelessWidget {
  const HomeQuoteCategories({super.key, this.onCategoryTap});

  final ValueChanged<HomeQuoteCategory>? onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final category in homeQuoteCategories)
          SizedBox(
            width: 76,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onCategoryTap == null
                  ? null
                  : () => onCategoryTap!(category),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.homeCategoryTile,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(category.icon, color: AppColors.loginAccent),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
