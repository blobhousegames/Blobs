import 'lobby.dart';
import 'player.dart';
import 'playing_card.dart';

enum GamePhase {
  dealerSelection,
  bidding,
  playing,
  scoring,
  roundComplete,
  gameComplete,
}

class PlayedCard {
  const PlayedCard({
    required this.player,
    required this.card,
  });

  final Player player;
  final PlayingCard card;
}

class Game {
  const Game({
    required this.lobby,
    required this.players,
    required this.roundNumber,
    required this.cardsPerPlayer,
    required this.dealerIndex,
    required this.currentPlayerIndex,
    required this.phase,
    required this.trumpSuit,
    required this.currentTrick,
  });

  final Lobby lobby;
  final List<Player> players;

  final int roundNumber;
  final int cardsPerPlayer;
  final int dealerIndex;
  final int currentPlayerIndex;

  final GamePhase phase;
  final Suit? trumpSuit;
  final List<PlayedCard> currentTrick;

  Player get dealer => players[dealerIndex];

  Player get currentPlayer => players[currentPlayerIndex];

  Game copyWith({
    Lobby? lobby,
    List<Player>? players,
    int? roundNumber,
    int? cardsPerPlayer,
    int? dealerIndex,
    int? currentPlayerIndex,
    GamePhase? phase,
    Suit? trumpSuit,
    List<PlayedCard>? currentTrick,
  }) {
    return Game(
      lobby: lobby ?? this.lobby,
      players: players ?? this.players,
      roundNumber: roundNumber ?? this.roundNumber,
      cardsPerPlayer: cardsPerPlayer ?? this.cardsPerPlayer,
      dealerIndex: dealerIndex ?? this.dealerIndex,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      phase: phase ?? this.phase,
      trumpSuit: trumpSuit ?? this.trumpSuit,
      currentTrick: currentTrick ?? this.currentTrick,
    );
  }
}