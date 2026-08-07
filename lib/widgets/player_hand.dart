import 'package:flutter/material.dart';

import '../models/playing_card.dart';
import 'playing_card_widget.dart';

class PlayerHand extends StatelessWidget {
  const PlayerHand({
    required this.cards,
    required this.legalCards,
    required this.selectedCard,
    required this.enabled,
    required this.onCardSelected,
    super.key,
  });

  final List<PlayingCard> cards;
  final List<PlayingCard> legalCards;
  final PlayingCard? selectedCard;
  final bool enabled;
  final ValueChanged<PlayingCard> onCardSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 122,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final card = cards[index];

          final isLegal =
              enabled && legalCards.contains(card);

          return GestureDetector(
            onTap: isLegal
                ? () => onCardSelected(card)
                : null,
            child: PlayingCardWidget(
              card: card,
              isPlayable: isLegal,
              isSelected: selectedCard == card,
            ),
          );
        },
      ),
    );
  }
}