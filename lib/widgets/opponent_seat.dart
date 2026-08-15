import 'package:flutter/material.dart';

import '../models/player.dart';
import 'blob_avatar.dart';

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
    return AnimatedScale(
      duration: const Duration(
        milliseconds: 220,
      ),
      scale: isCurrentPlayer ? 1.06 : 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlobAvatar(
  isActive: isCurrentPlayer,
),

          const SizedBox(height: 7),

          Text(
            player.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFF7F0DC),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            'Bid ${player.bid ?? '-'} • ${player.tricksWon}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFD8D0BD),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}