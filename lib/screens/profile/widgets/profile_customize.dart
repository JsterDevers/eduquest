import 'package:flutter/material.dart';
import '../profile_controller.dart';
import '../profile_models.dart';

class ProfileCustomizeSheet extends StatefulWidget {
  final ProfileController controller;
  final VoidCallback onClose;

  const ProfileCustomizeSheet({
    super.key,
    required this.controller,
    required this.onClose,
  });

  @override
  State<ProfileCustomizeSheet> createState() => _ProfileCustomizeSheetState();
}

class _ProfileCustomizeSheetState extends State<ProfileCustomizeSheet> {
  static const String _defaultPreviewAsset =
      'assets/Pixel version/Body (Skin)/Skin1.png';

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
              'Customize Profile',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3E2C78),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Choose from the pixel avatar items you already own.',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 8,
                color: Color(0xFF5E4B82),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            Center(
              child: SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildPreviewImage(widget.controller.currentSkinAsset),
                    _buildPreviewImage(widget.controller.currentClothesAsset),
                    _buildPreviewImage(widget.controller.currentHairAsset),
                    _buildPreviewImage(widget.controller.currentEyesAsset),
                    _buildPreviewImage(widget.controller.currentMouthAsset),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Preview Avatar',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 8,
                color: Color(0xFF362B5D),
              ),
            ),
            const SizedBox(height: 20),
            ...widget.controller.customizationCategories.map(
              (category) => _buildCategory(context, category),
            ),
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

  Widget _buildPreviewImage(String assetPath) {
    return Image.asset(
      assetPath,
      width: 140,
      height: 140,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          _defaultPreviewAsset,
          width: 140,
          height: 140,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/coin.png',
              width: 140,
              height: 140,
              fit: BoxFit.contain,
            );
          },
        );
      },
    );
  }

  Widget _buildCategory(BuildContext context, CustomizationCategory category) {
    final selectedIndex = widget.controller.selectedIndexForCategory(
      category.name,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.name,
          style: const TextStyle(
            fontFamily: 'PressStart2P',
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: Color(0xFF5E4B82),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(category.items.length, (index) {
            final item = category.items[index];
            final owned = widget.controller.isCustomizationOwned(item.id);
            final selected = selectedIndex == index;

            return GestureDetector(
              onTap: owned
                  ? () => setState(() {
                      widget.controller.updateCustomization(
                        category.name,
                        index,
                      );
                    })
                  : null,
              child: Opacity(
                opacity: owned ? 1.0 : 0.4,
                child: Container(
                  width: 72,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF6A3EA8)
                        : const Color(0xFFF7F3FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF5638A7)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: Image.asset(
                          item.assetPath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              _defaultPreviewAsset,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 24,
                                    color: Color(0xFF9E8CCF),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'PressStart2P',
                          fontSize: 6,
                          color: Color(0xFF4F3E84),
                        ),
                      ),
                      if (!owned)
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Icon(
                            Icons.lock,
                            size: 10,
                            color: Color(0xFF8B76A7),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}