import 'package:flutter/material.dart';

// PROFILE STAT CARD: change summary stat card layout or icon handling here.
class StatCard extends StatelessWidget {
  final String label;
  final String caption;
  final IconData? iconData;
  final String? asset;

  const StatCard({
    super.key,
    this.iconData,
    this.asset,
    required this.label,
    required this.caption,
  }) : assert(
         iconData != null || asset != null,
         'Either iconData or asset must be provided.',
       );

  @override
  Widget build(BuildContext context) {
    final hasAsset = asset != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasAsset)
            Image.asset(asset!, width: 26, height: 26)
          else
            Icon(iconData, size: 26, color: const Color(0xFF6A4BCC)),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'PressStart2P',
              fontWeight: FontWeight.w700,
              fontSize: 8,
              color: Color(0xFF442C7E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: const TextStyle(
              fontFamily: 'PressStart2P',
              color: Color(0xFF5C4E86),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}