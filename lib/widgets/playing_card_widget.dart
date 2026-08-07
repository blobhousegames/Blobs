import 'package:flutter/material.dart';

import '../models/playing_card.dart';

class PlayingCardWidget extends StatelessWidget {
  const PlayingCardWidget({
    required this.card,
    required this.isPlayable,
    required this.isSelected,
    super.key,
  });

  final PlayingCard card;
  final bool isPlayable;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 160,
      ),
      transform: Matrix4.translationValues(
        0,
        isSelected ? -10 : 0,
        0,
      ),
      width: 72,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Colors.white
              : const Color(0xFFE7D7A7),
          width: isSelected ? 3 : 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Opacity(
        opacity: isPlayable ? 1 : 0.32,
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            '${card.rankLabel}${card.suitSymbol}',
            style: TextStyle(
              color: card.isRed
                  ? const Color(0xFFB63C3C)
                  : const Color(0xFF17201D),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}