import '../models/game.dart';
import '../models/player.dart';
import '../models/playing_card.dart';

class TrickResult {
  const TrickResult({
    required this.game,
    required this.trickComplete,
  });

  final Game game;
  final bool trickComplete;
}

class TrickEngine {
  TrickEngine._();

  static List<PlayingCard> legalCards(Game game) {
    if (game.phase != GamePhase.playing) {
      return const [];
    }

    final player = game.currentPlayer;

    if (game.currentTrick.isEmpty) {
      return player.hand;
    }

    final leadSuit = game.currentTrick.first.card.suit;

    final matchingSuit = player.hand
        .where((card) => card.suit == leadSuit)
        .toList();

    if (matchingSuit.isNotEmpty) {
      return matchingSuit;
    }

    return player.hand;
  }

  static TrickResult playCard({
    required Game game,
    required PlayingCard card,
  }) {
    if (game.phase != GamePhase.playing) {
      throw StateError(
        'Cards can only be played during the playing phase.',
      );
    }

    final currentPlayer = game.currentPlayer;
    final legalCards = TrickEngine.legalCards(game);

    if (!legalCards.contains(card)) {
      throw ArgumentError(
        '${card.rankLabel}${card.suitSymbol} cannot be played now.',
      );
    }

    final updatedPlayers = List<Player>.from(game.players);

    final updatedHand = List<PlayingCard>.from(
      currentPlayer.hand,
    )..remove(card);

    updatedPlayers[game.currentPlayerIndex] =
        currentPlayer.copyWith(
      hand: updatedHand,
    );

    final updatedTrick = [
      ...game.currentTrick,
      PlayedCard(
        player: currentPlayer,
        card: card,
      ),
    ];
final updatedTrumpSuit =
    game.trumpSuit == null && game.currentTrick.isEmpty
        ? card.suit
        : game.trumpSuit;
    final trickComplete =
        updatedTrick.length == updatedPlayers.length;

    if (trickComplete) {
      return TrickResult(
        game: game.copyWith(
          players: updatedPlayers,
          lobby: game.lobby.copyWith(
            players: updatedPlayers,
          ),
          currentTrick: updatedTrick,
          trumpSuit: updatedTrumpSuit,
        ),
        trickComplete: true,
      );
    }

    final nextPlayerIndex =
        (game.currentPlayerIndex + 1) %
            updatedPlayers.length;

    return TrickResult(
  game: game.copyWith(
    players: updatedPlayers,
    lobby: game.lobby.copyWith(
      players: updatedPlayers,
    ),
    currentPlayerIndex: nextPlayerIndex,
    currentTrick: updatedTrick,
    trumpSuit: updatedTrumpSuit,
  ),
  trickComplete: false,
);
  }
static Game resolveCompletedTrick(Game game) {
  if (game.currentTrick.length != game.players.length) {
    throw StateError(
      'The trick must be complete before it can be resolved.',
    );
  }

  final winningPlayerIndex = winnerIndex(game);
  final updatedPlayers = List<Player>.from(game.players);
  final winner = updatedPlayers[winningPlayerIndex];

  updatedPlayers[winningPlayerIndex] = winner.copyWith(
    tricksWon: winner.tricksWon + 1,
  );

  final roundComplete = updatedPlayers.every(
    (player) => player.hand.isEmpty,
  );

  return game.copyWith(
    players: updatedPlayers,
    lobby: game.lobby.copyWith(
      players: updatedPlayers,
    ),
    currentPlayerIndex: winningPlayerIndex,
    currentTrick: const [],
    phase: roundComplete
        ? GamePhase.roundComplete
        : GamePhase.playing,
  );
}
  static int winnerIndex(Game game) {
    if (game.currentTrick.length != game.players.length) {
      throw StateError(
        'The trick is not complete.',
      );
    }

    final leadSuit = game.currentTrick.first.card.suit;
    final trumpSuit = game.trumpSuit;

    var winningIndex = 0;
    var winningCard = game.currentTrick.first.card;

    for (
      var index = 1;
      index < game.currentTrick.length;
      index++
    ) {
      final challenger =
          game.currentTrick[index].card;

      if (_beats(
        challenger: challenger,
        currentWinner: winningCard,
        leadSuit: leadSuit,
        trumpSuit: trumpSuit,
      )) {
        winningCard = challenger;
        winningIndex = index;
      }
    }

    final winningPlayer =
        game.currentTrick[winningIndex].player;

    return game.players.indexWhere(
      (player) => player.id == winningPlayer.id,
    );
  }

  static bool _beats({
    required PlayingCard challenger,
    required PlayingCard currentWinner,
    required Suit leadSuit,
    required Suit? trumpSuit,
  }) {
    final challengerIsTrump =
        trumpSuit != null &&
        challenger.suit == trumpSuit;

    final winnerIsTrump =
        trumpSuit != null &&
        currentWinner.suit == trumpSuit;

    if (challengerIsTrump && !winnerIsTrump) {
      return true;
    }

    if (!challengerIsTrump && winnerIsTrump) {
      return false;
    }

    if (challenger.suit == currentWinner.suit) {
      return challenger.rank > currentWinner.rank;
    }

    if (challenger.suit == leadSuit &&
        currentWinner.suit != leadSuit) {
      return true;
    }

    return false;
  }
}