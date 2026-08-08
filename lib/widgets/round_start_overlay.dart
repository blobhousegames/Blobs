import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/playing_card.dart';

class RoundStartOverlay extends StatelessWidget {
  const RoundStartOverlay({
    required this.game,
    required this.secondsRemaining,
    super.key,
  });

  final Game game;
  final int secondsRemaining;

  @override
  Widget build(BuildContext context) {
return Container(
  width: 260,
  padding: const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 10,
  ),
  decoration: BoxDecoration(
    color: const Color(0xFFE7D7A7),
    borderRadius: BorderRadius.circular(24),
    boxShadow: const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 18,
        offset: Offset(0, 7),
      ),
    ],
  ),
  child: FittedBox(
    fit: BoxFit.scaleDown,
    child: SizedBox(
      width: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ROUND ${game.roundNumber}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF173B30),
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${game.cardsPerPlayer} CARDS',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF315C4D),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _trumpText(game.trumpSuit),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF173B30),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (game.trumpSuit == null) ...[
            const SizedBox(height: 3),
            const Text(
              'First card played sets trump',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF315C4D),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'Dealer: ${game.dealer.name}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF315C4D),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Starting in $secondsRemaining...',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF173B30),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    ),
  ),
);
  }

  static String _trumpText(Suit? suit) {
    switch (suit) {
      case Suit.diamonds:
        return '♦ DIAMONDS TRUMP';
      case Suit.spades:
        return '♠ SPADES TRUMP';
      case Suit.hearts:
        return '♥ HEARTS TRUMP';
      case Suit.clubs:
        return '♣ CLUBS TRUMP';
      case null:
        return 'NO TRUMP';
    }
  }
}