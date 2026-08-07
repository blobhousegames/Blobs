import '../models/game.dart';
import '../models/playing_card.dart';
import 'bidding_engine.dart';
import 'trick_engine.dart';

class TimeoutEngine {
  TimeoutEngine._();

  /// If a player fails to bid in time, use the highest legal bid.
  ///
  /// Usually this is the number of cards in the round.
  /// If the dealer cannot legally make that bid because it would cause
  /// the total bids to equal the number of cards, the next-highest
  /// legal bid is used instead.
  static int automaticBid(Game game) {
    if (game.phase != GamePhase.bidding) {
      throw StateError(
        'Automatic bidding can only occur during bidding.',
      );
    }

    final legalBids = BiddingEngine.legalBids(game);

    if (legalBids.isEmpty) {
      throw StateError(
        'No legal bids are available.',
      );
    }

    return legalBids.reduce(
      (highest, bid) => bid > highest ? bid : highest,
    );
  }

  /// Chooses the automatic card when a player runs out of time.
  ///
  /// Follow-suit is always respected because we only choose from
  /// TrickEngine.legalCards().
  ///
  /// From those legal cards:
  /// 1. Play the highest trump if trump is legally available.
  /// 2. Otherwise play the highest legal card.
  static PlayingCard automaticCard(Game game) {
    if (game.phase != GamePhase.playing) {
      throw StateError(
        'Automatic card play can only occur during card play.',
      );
    }

    final legalCards = TrickEngine.legalCards(game);

    if (legalCards.isEmpty) {
      throw StateError(
        '${game.currentPlayer.name} has no legal cards.',
      );
    }

    final trumpSuit = game.trumpSuit;

    if (trumpSuit != null) {
      final legalTrumpCards = legalCards
          .where(
            (card) => card.suit == trumpSuit,
          )
          .toList();

      if (legalTrumpCards.isNotEmpty) {
        legalTrumpCards.sort(
          (first, second) =>
              second.rank.compareTo(first.rank),
        );

        return legalTrumpCards.first;
      }
    }

    final sortedLegalCards =
        List<PlayingCard>.from(legalCards)
          ..sort(
            (first, second) =>
                second.rank.compareTo(first.rank),
          );

    return sortedLegalCards.first;
  }
}