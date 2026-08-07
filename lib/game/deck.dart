import 'dart:math';

import '../models/playing_card.dart';

class Deck {
  Deck._();

  static List<PlayingCard> createStandardDeck() {
    return [
      for (final suit in Suit.values)
        for (var rank = 2; rank <= 14; rank++)
          PlayingCard(
            suit: suit,
            rank: rank,
          ),
    ];
  }

  static List<PlayingCard> shuffled({
    Random? random,
  }) {
    final deck = createStandardDeck();
    deck.shuffle(random);
    return deck;
  }
}