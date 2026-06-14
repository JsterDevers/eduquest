import 'package:flutter/material.dart';
import '../profile_controller.dart';
import '../profile_models.dart';
import '../../../services/player_stats.dart';

class ProfileMarketSheet extends StatefulWidget {
  final ProfileController controller;
  final VoidCallback onClose;

  const ProfileMarketSheet({
    super.key,
    required this.controller,
    required this.onClose,
  });

  @override
  State<ProfileMarketSheet> createState() => _ProfileMarketSheetState();
}

class _ProfileMarketSheetState extends State<ProfileMarketSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Market',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3E2C78),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Coins: ${PlayerStats.instance.coins}',
              style: const TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 10,
                color: Color(0xFF5E4B82),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Scenery Shop',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5E4B82),
              ),
            ),
            const SizedBox(height: 12),
            ...widget.controller.marketItems
                .where((item) => item.id.startsWith('scenery'))
                .map((item) => _buildMarketRow(item)),
            const SizedBox(height: 18),
            const Text(
              'Avatar Extras',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5E4B82),
              ),
            ),
            const SizedBox(height: 12),
            ...widget.controller.marketItems
                .where((item) => !item.id.startsWith('scenery'))
                .map((item) => _buildMarketRow(item)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A3EA8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 8,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketRow(MarketItem item) {
    final owned = widget.controller.isMarketItemOwned(item.id);
    final isSelected = item.id == widget.controller.currentSceneryId;
    final canAfford = PlayerStats.instance.coins >= item.price;
    final buttonLabel = owned
        ? isSelected
              ? 'Selected'
              : 'Select'
        : 'Buy ${item.price}';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: const Color(0xFFF7F3FF),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE4FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item.icon, color: const Color(0xFF6A3EA8)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3E2D72),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 6,
                      color: Color(0xFF5D4D81),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: owned
                  ? isSelected
                        ? null
                        : () {
                            setState(() {
                              widget.controller.updateSceneryById(item.id);
                            });
                          }
                  : canAfford
                  ? () {
                      setState(() {
                        widget.controller.purchaseMarketItem(item.id);
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: owned && isSelected
                    ? const Color(0xFFBEB4FF)
                    : const Color(0xFF6A3EA8),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 7,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}