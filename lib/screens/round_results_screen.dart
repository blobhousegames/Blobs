import 'package:flutter/material.dart';

import '../game/round_engine.dart';
import '../game/scoring_engine.dart';
import '../models/game.dart';
import '../models/player.dart';
import 'table_screen.dart';

class RoundResultsScreen extends StatelessWidget {
  const RoundResultsScreen({
    required this.game,
    super.key,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    final scoredGame = game.phase == GamePhase.scoring
        ? game
        : ScoringEngine.scoreCompletedRound(game);

    final leaderboard = ScoringEngine.leaderboard(
      scoredGame,
    );

    final isFinalRound =
        scoredGame.roundNumber >=
            RoundEngine.cardsByRound.length;

    return Scaffold(
      backgroundColor: const Color(0xFF173B30),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          isFinalRound
              ? 'Final Results'
              : 'Round ${scoredGame.roundNumber} Results',
        ),
        backgroundColor: const Color(0xFF173B30),
        foregroundColor: const Color(0xFFF7F0DC),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 520,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  Text(
                    isFinalRound
                        ? 'GAME COMPLETE'
                        : 'ROUND COMPLETE',
                    style: const TextStyle(
                      color: Color(0xFFF7F0DC),
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    isFinalRound
                        ? 'Lowest score wins.'
                        : 'Exact bid: +0 • Blob: +1',
                    style: const TextStyle(
                      color: Color(0xFFD8D0BD),
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Expanded(
                    child: ListView.separated(
                      itemCount: leaderboard.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final player =
                            leaderboard[index];

                        return _RoundResultTile(
                          player: player,
                          position: index + 1,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FilledButton.icon(
                      onPressed: () {
                        if (isFinalRound) {
                          Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          );
                          return;
                        }

                        final nextGame =
                            RoundEngine.startNextRound(
                          scoredGame.copyWith(
                            phase:
                                GamePhase.roundComplete,
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TableScreen(
                              game: nextGame,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        isFinalRound
                            ? Icons.home_rounded
                            : Icons.skip_next_rounded,
                      ),
                      label: Text(
                        isFinalRound
                            ? 'Return Home'
                            : 'Start Next Round',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFE7D7A7),
                        foregroundColor:
                            const Color(0xFF173B30),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundResultTile extends StatelessWidget {
  const _RoundResultTile({
    required this.player,
    required this.position,
  });

  final Player player;
  final int position;

  @override
  Widget build(BuildContext context) {
    final hitBid = ScoringEngine.hitBid(player);
    final roundScore =
        ScoringEngine.roundScore(player);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x332A5A49),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hitBid
              ? const Color(0xFF6E9B78)
              : const Color(0xFF9A6B6B),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              '$position',
              style: const TextStyle(
                color: Color(0xFFE7D7A7),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                    color: Color(0xFFF7F0DC),
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bid ${player.bid} • '
                  '${player.tricksWon} tricks',
                  style: const TextStyle(
                    color: Color(0xFFD8D0BD),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Text(
            hitBid ? '😁' : '😭',
            style: const TextStyle(
              fontSize: 28,
            ),
          ),

          const SizedBox(width: 14),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                '+$roundScore',
                style: TextStyle(
                  color: hitBid
                      ? const Color(0xFF92C49B)
                      : const Color(0xFFE19A9A),
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Total ${player.score}',
                style: const TextStyle(
                  color: Color(0xFFF7F0DC),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}