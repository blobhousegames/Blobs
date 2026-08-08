import 'package:flutter/material.dart';

import '../models/playing_card.dart';

class TrickCollectionOverlay extends StatelessWidget {
  const TrickCollectionOverlay({
    required this.cards,
    required this.collectTowardLocalPlayer,
    required this.animate,
    super.key,
  });

  final List<PlayingCard> cards;
  final bool collectTowardLocalPlayer;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: AnimatedSlide(
        duration: const Duration(
          milliseconds: 500,
        ),
        curve: Curves.easeInCubic,
        offset: animate
            ? Offset(
                0,
                collectTowardLocalPlayer ? 2.2 : -2.2,
              )
            : Offset.zero,
        child: AnimatedOpacity(
          duration: const Duration(
            milliseconds: 400,
          ),
          opacity: animate ? 0 : 1,
          child: Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final card in cards)
                _CollectionCard(
                  card: card,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({
    required this.card,
  });

  final PlayingCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 78,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3E6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.topLeft,
      child: Text(
        '${card.rankLabel}${card.suitSymbol}',
        style: TextStyle(
          color: card.isRed
              ? const Color(0xFFB63C3C)
              : const Color(0xFF17201D),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}