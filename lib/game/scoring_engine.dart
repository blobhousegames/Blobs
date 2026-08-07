import '../models/game.dart';
import '../models/player.dart';

class ScoringEngine {
  ScoringEngine._();

  static Game scoreCompletedRound(Game game) {
    if (game.phase != GamePhase.roundComplete) {
      throw StateError(
        'The round must be complete before scoring.',
      );
    }

    final updatedPlayers = <Player>[
      for (final player in game.players)
        player.copyWith(
          score: player.score + _roundPenalty(player),
        ),
    ];

    return game.copyWith(
      players: updatedPlayers,
      lobby: game.lobby.copyWith(
        players: updatedPlayers,
      ),
      phase: GamePhase.scoring,
    );
  }

  static int roundScore(Player player) {
    return _roundPenalty(player);
  }

  static bool hitBid(Player player) {
    final bid = player.bid;

    if (bid == null) {
      throw StateError(
        '${player.name} does not have a submitted bid.',
      );
    }

    return bid == player.tricksWon;
  }

  static List<Player> leaderboard(Game game) {
    final sortedPlayers = List<Player>.from(
      game.players,
    );

    sortedPlayers.sort(
      (first, second) =>
          first.score.compareTo(second.score),
    );

    return sortedPlayers;
  }

  static List<Player> winners(Game game) {
    if (game.players.isEmpty) {
      return const [];
    }

    final lowestScore = game.players
        .map((player) => player.score)
        .reduce(
          (first, second) =>
              first < second ? first : second,
        );

    return game.players
        .where(
          (player) => player.score == lowestScore,
        )
        .toList();
  }

  static int _roundPenalty(Player player) {
    final bid = player.bid;

    if (bid == null) {
      throw StateError(
        '${player.name} cannot be scored without a bid.',
      );
    }

    return bid == player.tricksWon ? 0 : 1;
  }
}