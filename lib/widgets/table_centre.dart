import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/playing_card.dart';
import 'bid_selector.dart';

class TableCentre extends StatelessWidget {
  const TableCentre({
    required this.game,
    required this.isLocalPlayersTurn,
    required this.resolvingTrick,
    required this.trickWinnerName,
    required this.onBidConfirmed,
    required this.isCollectingTrick,
required this.collectTowardLocalPlayer,
    super.key,
  });

  final Game game;
  final bool isLocalPlayersTurn;
  final bool resolvingTrick;
  final String? trickWinnerName;
  final ValueChanged<int> onBidConfirmed;
final bool isCollectingTrick;
final bool collectTowardLocalPlayer;
  @override
  Widget build(BuildContext context) {
    if (trickWinnerName != null) {
      return _TrickWinnerBanner(
        winnerName: trickWinnerName!,
      );
    }

    if (game.phase == GamePhase.bidding) {
      if (isLocalPlayersTurn) {
        return SizedBox(
          width: 230,
          child: BidSelector(
            maximumBid: game.cardsPerPlayer,
            onConfirmed: onBidConfirmed,
          ),
        );
      }

      return _WaitingPanel(
        message:
            'Waiting for ${game.currentPlayer.name} to bid...',
      );
    }

    if (game.phase == GamePhase.roundComplete) {
      return const _WaitingPanel(
        message: 'Round complete',
      );
    }

if (resolvingTrick && !isCollectingTrick) {
  return _CurrentTrick(
    game: game,
    footer: 'Resolving trick...',
  );
}

return AnimatedSlide(
  duration: const Duration(
    milliseconds: 450,
  ),
  curve: Curves.easeInCubic,
  offset: isCollectingTrick
      ? Offset(
          0,
          collectTowardLocalPlayer
              ? 1.8
              : -1.8,
        )
      : Offset.zero,
  child: AnimatedOpacity(
    duration: const Duration(
      milliseconds: 350,
    ),
    opacity:
        isCollectingTrick ? 0 : 1,
    child: _CurrentTrick(
      game: game,
      footer: game.currentTrick.isEmpty
          ? '${game.currentPlayer.name} leads'
          : '${game.currentPlayer.name} to play',
    ),
  ),
);
  }
}

class _TrickWinnerBanner extends StatelessWidget {
  const _TrickWinnerBanner({
    required this.winnerName,
  });

  final String winnerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE7D7A7),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFF173B30),
            size: 38,
          ),
          const SizedBox(height: 10),
          Text(
            '$winnerName wins the trick',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF173B30),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Next trick starting...',
            style: TextStyle(
              color: Color(0xFF315C4D),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaitingPanel extends StatelessWidget {
  const _WaitingPanel({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xDD173B30),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE7D7A7),
        ),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFF7F0DC),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _CurrentTrick extends StatelessWidget {
  const _CurrentTrick({
    required this.game,
    required this.footer,
  });

  final Game game;
  final String footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 230,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0x33102D25),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF5F8878),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'CURRENT TRICK',
            style: TextStyle(
              color: Color(0xFFF7F0DC),
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 14),

          if (game.currentTrick.isEmpty)
            const Icon(
              Icons.layers_rounded,
              color: Color(0xFFE7D7A7),
              size: 38,
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                for (final played in game.currentTrick)
                  _PlayedCardWidget(
                    playerName: played.player.name,
                    card: played.card,
                  ),
              ],
            ),

          const SizedBox(height: 14),

          Text(
            footer,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFD8D0BD),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
class _PlayedCardWidget extends StatelessWidget {
  const _PlayedCardWidget({
    required this.playerName,
    required this.card,
  });

  final String playerName;
  final PlayingCard card;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 78,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F3E6),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.topLeft,
          child: Text(
            '${card.rankLabel}${card.suitSymbol}',
            style: TextStyle(
              color: card.isRed
                  ? const Color(0xFFB63C3C)
                  : const Color(0xFF17201D),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          playerName,
          style: const TextStyle(
            color: Color(0xFFD8D0BD),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}