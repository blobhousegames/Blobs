enum Suit {
  diamonds,
  spades,
  hearts,
  clubs,
}

class PlayingCard {
  const PlayingCard({
    required this.suit,
    required this.rank,
  });

  final Suit suit;
  final int rank;

  String get rankLabel {
    switch (rank) {
      case 14:
        return 'A';
      case 13:
        return 'K';
      case 12:
        return 'Q';
      case 11:
        return 'J';
      default:
        return rank.toString();
    }
  }

  String get suitSymbol {
    switch (suit) {
      case Suit.diamonds:
        return '♦';
      case Suit.spades:
        return '♠';
      case Suit.hearts:
        return '♥';
      case Suit.clubs:
        return '♣';
    }
  }

  bool get isRed =>
      suit == Suit.hearts ||
      suit == Suit.diamonds;
}