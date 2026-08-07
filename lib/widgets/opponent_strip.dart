import 'package:flutter/material.dart';

import '../models/player.dart';
import 'opponent_seat.dart';

class OpponentStrip extends StatelessWidget {
  const OpponentStrip({
    required this.players,
    required this.currentPlayerId,
    super.key,
  });

  final List<Player> players;
  final String currentPlayerId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: players.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final player = players[index];

          return OpponentSeat(
            player: player,
            isCurrentPlayer:
                player.id == currentPlayerId,
          );
        },
      ),
    );
  }
}