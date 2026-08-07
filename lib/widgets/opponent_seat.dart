import 'package:flutter/material.dart';

import '../models/player.dart';

class OpponentSeat extends StatelessWidget {
  const OpponentSeat({
    required this.player,
    required this.isCurrentPlayer,
    super.key,
  });

  final Player player;
  final bool isCurrentPlayer;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      width: 130,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xDD173B30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentPlayer
              ? const Color(0xFFE7D7A7)
              : const Color(0xFF668D7E),
          width: isCurrentPlayer ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 17,
            backgroundColor: Color(0xFFE7D7A7),
            foregroundColor: Color(0xFF173B30),
            child: Icon(
              Icons.person_rounded,
              size: 19,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFF7F0DC),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Bid ${player.bid ?? '-'} • '
                  '${player.tricksWon} tricks',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFD8D0BD),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}