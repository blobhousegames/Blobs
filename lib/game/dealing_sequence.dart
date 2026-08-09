class DealingSequence {
  const DealingSequence._();

  static List<int> build({
    required int playerCount,
    required int cardsPerPlayer,
    required int dealerIndex,
  }) {
    if (playerCount <= 0 || cardsPerPlayer <= 0) {
      return const [];
    }

    final sequence = <int>[];

    final firstRecipient =
        (dealerIndex + 1) % playerCount;

    for (var cardNumber = 0;
        cardNumber < cardsPerPlayer;
        cardNumber++) {
      for (var offset = 0;
          offset < playerCount;
          offset++) {
        final playerIndex =
            (firstRecipient + offset) %
                playerCount;

        sequence.add(playerIndex);
      }
    }

    return sequence;
  }
}