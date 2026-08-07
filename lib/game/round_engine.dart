import '../models/game.dart';
import '../models/player.dart';
import '../models/playing_card.dart';
import 'dealer.dart';
import 'deck.dart';

class RoundEngine {
  RoundEngine._();

  static const List<int> cardsByRound = [
    7,
    6,
    5,
    4,
    3,
    2,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
  ];

  static int cardsForRound(int roundNumber) {
    if (roundNumber < 1 ||
        roundNumber > cardsByRound.length) {
      throw RangeError(
        'Round number must be between 1 and 13.',
      );
    }

    return cardsByRound[roundNumber - 1];
  }

  static Suit? trumpForRound(int roundNumber) {
    if (roundNumber < 1 ||
        roundNumber > cardsByRound.length) {
      throw RangeError(
        'Round number must be between 1 and 13.',
      );
    }

    final trumpIndex = (roundNumber - 1) % 5;

    switch (trumpIndex) {
      case 0:
        return Suit.diamonds;
      case 1:
        return Suit.spades;
      case 2:
        return Suit.hearts;
      case 3:
        return Suit.clubs;
      case 4:
        return null;
    }

    throw StateError('Unable to determine trump.');
  }

  static Game startNextRound(Game game) {
    if (game.phase != GamePhase.roundComplete) {
      throw StateError(
        'The current round must be complete before '
        'starting the next round.',
      );
    }

    final nextRoundNumber = game.roundNumber + 1;

    if (nextRoundNumber > cardsByRound.length) {
      return game.copyWith(
        phase: GamePhase.gameComplete,
        currentTrick: const [],
      );
    }

    final cardsEach = cardsForRound(
      nextRoundNumber,
    );

    final shuffledDeck = Deck.shuffled();

    final deal = Dealer.deal(
      deck: shuffledDeck,
      players: game.players.length,
      cardsEach: cardsEach,
    );

    final updatedPlayers = <Player>[
      for (var index = 0;
          index < game.players.length;
          index++)
        game.players[index].copyWith(
          hand: _sortHand(deal.hands[index]),
          clearBid: true,
          tricksWon: 0,
        ),
    ];

    final nextDealerIndex =
        (game.dealerIndex + 1) %
            updatedPlayers.length;

    final firstBidderIndex =
        (nextDealerIndex + 1) %
            updatedPlayers.length;

    return game.copyWith(
      lobby: game.lobby.copyWith(
        players: updatedPlayers,
      ),
      players: updatedPlayers,
      roundNumber: nextRoundNumber,
      cardsPerPlayer: cardsEach,
      dealerIndex: nextDealerIndex,
      currentPlayerIndex: firstBidderIndex,
      phase: GamePhase.bidding,
      trumpSuit: trumpForRound(
        nextRoundNumber,
      ),
      currentTrick: const [],
    );
  }

  static List<PlayingCard> _sortHand(
    List<PlayingCard> hand,
  ) {
    final sortedHand =
        List<PlayingCard>.from(hand);

    sortedHand.sort((first, second) {
      final suitComparison =
          first.suit.index.compareTo(
        second.suit.index,
      );

      if (suitComparison != 0) {
        return suitComparison;
      }

      return second.rank.compareTo(
        first.rank,
      );
    });

    return sortedHand;
  }
}