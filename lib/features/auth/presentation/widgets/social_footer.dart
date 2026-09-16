import 'package:flutter/material.dart';

import 'social_icon.dart';

class SocialFooter extends StatelessWidget {
  const SocialFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Acesse através das redes sociais',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialIcon(label: 'G'),
            SizedBox(width: 16),
            SocialIcon(label: 'f'),
            SizedBox(width: 16),
            SocialIcon(label: 'X'),
          ],
        ),
      ],
    );
  }
}
