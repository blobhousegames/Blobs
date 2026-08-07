import 'playing_card.dart';

class Player {
  const Player({
    required this.id,
    required this.name,
    this.isHost = false,
    this.isReady = false,
    this.isConnected = true,
    this.isAi = false,
    this.hand = const [],
    this.bid,
    this.tricksWon = 0,
    this.score = 0,
  });

  final String id;
  final String name;
  final bool isHost;
  final bool isReady;
  final bool isConnected;
  final bool isAi;

  final List<PlayingCard> hand;
  final int? bid;
  final int tricksWon;
  final int score;

  Player copyWith({
    String? id,
    String? name,
    bool? isHost,
    bool? isReady,
    bool? isConnected,
    bool? isAi,
    List<PlayingCard>? hand,
    int? bid,
    bool clearBid = false,
    int? tricksWon,
    int? score,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      isHost: isHost ?? this.isHost,
      isReady: isReady ?? this.isReady,
      isConnected: isConnected ?? this.isConnected,
      isAi: isAi ?? this.isAi,
      hand: hand ?? this.hand,
      bid: clearBid ? null : bid ?? this.bid,
      tricksWon: tricksWon ?? this.tricksWon,
      score: score ?? this.score,
    );
  }
}