import 'package:flutter/material.dart';

import '../game/table_layout.dart';
import '../models/player.dart';
import 'opponent_seat.dart';
import 'table_seat.dart';

class TableSeatLayer extends StatelessWidget {
  const TableSeatLayer({
    required this.players,
    required this.currentPlayerId,
    super.key,
  });

  final List<Player> players;
  final String currentPlayerId;

  @override
  Widget build(BuildContext context) {
    final seatPositions =
    TableLayout.positionsForPlayerCount(
  players.length,
);

    return Stack(
      children: [
        for (var index = 1;
            index < players.length;
            index++)
          TableSeat(
            alignment: seatPositions[index].alignment,
            offset: seatPositions[index].offset,
            child: OpponentSeat(
              player: players[index],
              isCurrentPlayer:
                  players[index].id ==
                      currentPlayerId,
            ),
          ),
      ],
    );
  }
}