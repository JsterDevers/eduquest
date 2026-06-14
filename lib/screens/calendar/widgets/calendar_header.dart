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
        const Padding(padding: EdgeInsets.all(0), child: PlayerStatsDisplay()),
        SizedBox(
          height: 75,
          width: double.infinity,
          child: Image.asset(imageAsset, fit: BoxFit.cover),
        ),
      ],
    );
  }
}