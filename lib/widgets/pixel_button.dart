import 'package:flutter/material.dart';

class PixelButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const PixelButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          // The 4px black border gives it that classic 8-bit look
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: const [
            // The offset creates the "hard shadow" seen in retro games
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Courier', // Standard blocky font
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}