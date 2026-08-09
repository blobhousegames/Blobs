import 'package:flutter/material.dart';

class TableLayout {
  const TableLayout._();

  static List<Alignment> alignmentsForPlayerCount(
    int playerCount,
  ) {
    switch (playerCount) {
      case 3:
        return const [
          Alignment.bottomCenter,
          Alignment.topLeft,
          Alignment.topRight,
        ];

      case 4:
        return const [
          Alignment.bottomCenter,
          Alignment.centerLeft,
          Alignment.topCenter,
          Alignment.centerRight,
        ];

      case 5:
        return const [
          Alignment.bottomCenter,
          Alignment.bottomLeft,
          Alignment.topLeft,
          Alignment.topCenter,
          Alignment.topRight,
        ];

      case 6:
        return const [
          Alignment.bottomCenter,
          Alignment.bottomLeft,
          Alignment.centerLeft,
          Alignment.topCenter,
          Alignment.centerRight,
          Alignment.bottomRight,
        ];

      case 7:
        return const [
          Alignment.bottomCenter,
          Alignment.bottomLeft,
          Alignment.centerLeft,
          Alignment.topLeft,
          Alignment.topCenter,
          Alignment.topRight,
          Alignment.centerRight,
        ];

      default:
        throw ArgumentError(
          'Unsupported player count',
        );
    }
  }
}