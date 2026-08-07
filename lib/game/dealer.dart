import '../models/playing_card.dart';

class DealResult {
  const DealResult({
    required this.hands,
    required this.remainingDeck,
  });

  final List<List<PlayingCard>> hands;
  final List<PlayingCard> remainingDeck;
}

class Dealer {
  Dealer._();

  static DealResult deal({
    required List<PlayingCard> deck,
    required int players,
    required int cardsEach,
  }) {
    final workingDeck = List<PlayingCard>.from(deck);

    final hands = List.generate(
      players,
      (_) => <PlayingCard>[],
    );

    for (var round = 0; round < cardsEach; round++) {
      for (var player = 0; player < players; player++) {
        hands[player].add(
          workingDeck.removeAt(0),
        );
      }
    }

    return DealResult(
      hands: hands,
      remainingDeck: workingDeck,
    );
  }
}