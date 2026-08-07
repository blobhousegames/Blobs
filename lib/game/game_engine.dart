import '../models/game.dart';
import '../models/lobby.dart';
import '../models/player.dart';
import '../models/playing_card.dart';
import 'dealer.dart';
import 'deck.dart';

class GameEngine {
  GameEngine._();

  static Game createGame({
    required Lobby lobby,
    required int dealerIndex,
  }) {
    if (lobby.players.length < 3) {
      throw StateError(
        'Blobs requires at least 3 players.',
      );
    }

    if (dealerIndex < 0 ||
        dealerIndex >= lobby.players.length) {
      throw RangeError(
        'Dealer index is outside the player list.',
      );
    }

    final shuffledDeck = Deck.shuffled();

    final deal = Dealer.deal(
      deck: shuffledDeck,
      players: lobby.players.length,
      cardsEach: 7,
    );

    final playersWithHands = [
      for (var index = 0;
          index < lobby.players.length;
          index++)
        lobby.players[index].copyWith(
          hand: _sortHand(deal.hands[index]),
          clearBid: true,
          tricksWon: 0,
        ),
    ];

    final updatedLobby = lobby.copyWith(
      players: playersWithHands,
    );

    final firstBidderIndex =
        (dealerIndex + 1) % playersWithHands.length;

    return Game(
      lobby: updatedLobby,
      players: playersWithHands,
      roundNumber: 1,
      cardsPerPlayer: 7,
      dealerIndex: dealerIndex,
      currentPlayerIndex: firstBidderIndex,
      phase: GamePhase.bidding,
      trumpSuit: Suit.diamonds,
      currentTrick: const [],
    );
  }

  static List<Player> createTemporaryPlayers({
    required int playerLimit,
  }) {
    return [
      const Player(
        id: 'player-carl',
        name: 'Carl',
        isHost: true,
        isReady: true,
      ),
      for (var index = 2;
          index <= playerLimit;
          index++)
        Player(
          id: 'player-$index',
          name: 'Player $index',
          isReady: true,
          isAi: true,
        ),
    ];
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