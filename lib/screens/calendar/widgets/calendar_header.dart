import 'package:flutter/material.dart';
import '../calendar_controller.dart';
import '../../../widgets/player_stats_display.dart';

class CalendarHeader extends StatelessWidget {
  final CalendarController controller;
  final VoidCallback onBackTap;
  final String imageAsset;

  const CalendarHeader({
    super.key,
    required this.controller,
    required this.onBackTap,
    this.imageAsset = 'assets/header_calendar.png',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(0), 
          child: PlayerStatsDisplay(),
        ),
        // FIXED FORMAT & SIZING: Removed height constraint and changed fit to fitWidth
        SizedBox(
          width: double.infinity,
          child: Image.asset(
            imageAsset, 
            fit: BoxFit.fitWidth, // Scales perfectly edge-to-edge matching your home and study methods banners!
          ),
        ),
      ],
    );
  }
}