import 'player.dart';

class Lobby {
  const Lobby({
    required this.id,
    required this.name,
    required this.code,
    required this.playerLimit,
    required this.timerSeconds,
    required this.isPrivate,
    required this.players,
  });

  final String id;
  final String name;
  final String code;
  final int playerLimit;
  final int timerSeconds;
  final bool isPrivate;
  final List<Player> players;

  int get connectedPlayerCount =>
      players.where((player) => player.isConnected).length;

  bool get canStart =>
      connectedPlayerCount >= 3 &&
      connectedPlayerCount <= playerLimit;

  Lobby copyWith({
    String? id,
    String? name,
    String? code,
    int? playerLimit,
    int? timerSeconds,
    bool? isPrivate,
    List<Player>? players,
  }) {
    return Lobby(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      playerLimit: playerLimit ?? this.playerLimit,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      isPrivate: isPrivate ?? this.isPrivate,
      players: players ?? this.players,
    );
  }
}