import 'package:flutter/material.dart';

class SeatPosition {
  const SeatPosition({
    required this.alignment,
    required this.offset,
  });

  final Alignment alignment;
  final Offset offset;
}

class TableLayout {
  const TableLayout._();

  static List<SeatPosition> positionsForPlayerCount(
    int playerCount,
  ) {
    switch (playerCount) {
      case 3:
        return const [
          // Carl / local player
          SeatPosition(
            alignment: Alignment.bottomCenter,
            offset: Offset(0, 0),
          ),

          // Opponent left
          SeatPosition(
            alignment: Alignment.centerLeft,
            offset: Offset(58, -34),
          ),

          // Opponent right
          SeatPosition(
            alignment: Alignment.centerRight,
            offset: Offset(-58, -34),
          ),
        ];

      case 4:
        return const [
          // Carl / local player
          SeatPosition(
            alignment: Alignment.bottomCenter,
            offset: Offset(0, 0),
          ),

          // Opponent left
          SeatPosition(
            alignment: Alignment.centerLeft,
            offset: Offset(58, -34),
          ),

          // Opponent upper-left
          SeatPosition(
            alignment: Alignment.topLeft,
            offset: Offset(390, 30),
          ),

          // Opponent right
          SeatPosition(
            alignment: Alignment.centerRight,
            offset: Offset(-58, -34),
          ),
        ];

      case 5:
        return const [
          // Carl / local player
          SeatPosition(
            alignment: Alignment.bottomCenter,
            offset: Offset(0, 0),
          ),

          // Opponent left-lower
          SeatPosition(
            alignment: Alignment.centerLeft,
            offset: Offset(58, 58),
          ),

          // Opponent left-upper
          SeatPosition(
            alignment: Alignment.topLeft,
            offset: Offset(250, 92),
          ),

          // Opponent right-upper
          SeatPosition(
            alignment: Alignment.topRight,
            offset: Offset(-250, 92),
          ),

          // Opponent right-lower
          SeatPosition(
            alignment: Alignment.centerRight,
            offset: Offset(-58, 58),
          ),
        ];

      case 6:
        return const [
          // Carl / local player
          SeatPosition(
            alignment: Alignment.bottomCenter,
            offset: Offset(0, 0),
          ),

          // Opponent left-lower
          SeatPosition(
            alignment: Alignment.centerLeft,
            offset: Offset(58, 82),
          ),

          // Opponent left-upper
          SeatPosition(
            alignment: Alignment.topLeft,
            offset: Offset(220, 86),
          ),

          // Opponent upper-right
          SeatPosition(
            alignment: Alignment.topRight,
            offset: Offset(-220, 86),
          ),

          // Opponent right-upper
          SeatPosition(
            alignment: Alignment.centerRight,
            offset: Offset(-58, -34),
          ),

          // Opponent right-lower
          SeatPosition(
            alignment: Alignment.centerRight,
            offset: Offset(-58, 118),
          ),
        ];

      case 7:
        return const [
          // Carl / local player
          SeatPosition(
            alignment: Alignment.bottomCenter,
            offset: Offset(0, 0),
          ),

          // Opponent left-lower
          SeatPosition(
            alignment: Alignment.centerLeft,
            offset: Offset(58, 118),
          ),

          // Opponent left-middle
          SeatPosition(
            alignment: Alignment.centerLeft,
            offset: Offset(58, -34),
          ),

          // Opponent left-upper
          SeatPosition(
            alignment: Alignment.topLeft,
            offset: Offset(220, 86),
          ),

          // Opponent right-upper
          SeatPosition(
            alignment: Alignment.topRight,
            offset: Offset(-220, 86),
          ),

          // Opponent right-middle
          SeatPosition(
            alignment: Alignment.centerRight,
            offset: Offset(-58, -34),
          ),

          // Opponent right-lower
          SeatPosition(
            alignment: Alignment.centerRight,
            offset: Offset(-58, 118),
          ),
        ];

      default:
        throw ArgumentError(
          'Unsupported player count: $playerCount',
        );
    }
  }
}