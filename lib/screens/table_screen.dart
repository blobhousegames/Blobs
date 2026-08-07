import 'dart:async';

import 'package:flutter/material.dart';

import '../game/bidding_engine.dart';
import '../game/timeout_engine.dart';
import '../game/trick_engine.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../models/playing_card.dart';
import '../widgets/playing_card_widget.dart';
import '../widgets/player_hand.dart';
import 'round_results_screen.dart';
import '../widgets/round_start_overlay.dart';
import '../widgets/table_centre.dart';
import '../widgets/opponent_strip.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({
    required this.game,
    super.key,
  });

  final Game game;

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  late Game _game;
  PlayingCard? _selectedCard;
PlayingCard? _animatingCard;

bool _isAnimatingCard = false;
  Timer? _turnTimer;
  late int _secondsRemaining;

bool _showRoundOverlay = true;
int _roundCountdown = 3;
Timer? _roundTimer;

  bool _resolvingTrick = false;
  bool _timeoutBeingHandled = false;
  String? _trickWinnerName;

  Player get _localPlayer => _game.players.first;

  bool get _isLocalPlayersTurn =>
      _game.currentPlayer.id == _localPlayer.id;

  List<PlayingCard> get _legalCards {
    if (_game.phase != GamePhase.playing ||
        !_isLocalPlayersTurn ||
        _resolvingTrick) {
      return const [];
    }

    return TrickEngine.legalCards(_game);
  }

  @override
  void initState() {
    super.initState();

    _game = widget.game;
    _secondsRemaining = _game.lobby.timerSeconds;

   WidgetsBinding.instance.addPostFrameCallback((_) {
  _startRoundCountdown();
});
  }

  @override
  void dispose() {
    _turnTimer?.cancel();
    super.dispose();
  }
void _startRoundCountdown() {
  _roundCountdown = 3;
  _showRoundOverlay = true;

  _roundTimer?.cancel();

  _roundTimer = Timer.periodic(
    const Duration(seconds: 1),
    (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_roundCountdown == 1) {
        timer.cancel();

        setState(() {
          _showRoundOverlay = false;
        });

        _startTurnTimer();
        _continueAutomaticTurns();

        return;
      }

      setState(() {
        _roundCountdown--;
      });
    },
  );
}

  void _startTurnTimer() {
    _turnTimer?.cancel();

    if (!mounted) {
      return;
    }

    if (_game.phase != GamePhase.bidding &&
        _game.phase != GamePhase.playing) {
      return;
    }

    setState(() {
      _secondsRemaining = _game.lobby.timerSeconds;
    });

    _turnTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_secondsRemaining <= 1) {
          timer.cancel();

          setState(() {
            _secondsRemaining = 0;
          });

          _handleTimeout();
          return;
        }

        setState(() {
          _secondsRemaining--;
        });
      },
    );
  }

  Future<void> _handleTimeout() async {
  if (_timeoutBeingHandled ||
      _resolvingTrick ||
      !mounted) {
    return;
  }

  _timeoutBeingHandled = true;

  try {
    if (_game.phase == GamePhase.bidding) {
      final playerName = _game.currentPlayer.name;

      final automaticBid =
          TimeoutEngine.automaticBid(_game);

      final result = BiddingEngine.submitBid(
        game: _game,
        bid: automaticBid,
      );

      setState(() {
        _game = result.game;
      });

      _showMessage(
        '$playerName timed out and bid $automaticBid.',
      );

      await _continueAutomaticTurns();
      return;
    }

    if (_game.phase == GamePhase.playing) {
      final playerName = _game.currentPlayer.name;

      final automaticCard =
          TimeoutEngine.automaticCard(_game);

      final result = TrickEngine.playCard(
        game: _game,
        card: automaticCard,
      );

setState(() {
  _game = result.game;
  _selectedCard = null;
  _isAnimatingCard = false;
  _animatingCard = null;
});

      _showMessage(
        '$playerName timed out. '
        '${automaticCard.rankLabel}'
        '${automaticCard.suitSymbol} was played.',
      );

      if (result.trickComplete) {
        await _resolveTrick();
      } else {
        await _continueAiCardPlay();
      }
    }
  } finally {
    _timeoutBeingHandled = false;
  }
}

  Future<void> _continueAutomaticTurns() async {
    await _continueAiBidding();
    await _continueAiCardPlay();
  }

  Future<void> _continueAiBidding() async {
    while (mounted &&
        _game.phase == GamePhase.bidding &&
        _game.currentPlayer.isAi) {
      _turnTimer?.cancel();

      await Future<void>.delayed(
        const Duration(milliseconds: 650),
      );

      if (!mounted ||
          _game.phase != GamePhase.bidding ||
          !_game.currentPlayer.isAi) {
        return;
      }

      final legalBids =
          BiddingEngine.legalBids(_game);

      final selectedBid = _chooseAiBid(
        player: _game.currentPlayer,
        legalBids: legalBids,
      );

      final result = BiddingEngine.submitBid(
        game: _game,
        bid: selectedBid,
      );

      setState(() {
        _game = result.game;
      });
    }

    if (mounted &&
        (_game.phase == GamePhase.bidding ||
            _game.phase == GamePhase.playing)) {
      _startTurnTimer();
    }
  }

  int _chooseAiBid({
    required Player player,
    required List<int> legalBids,
  }) {
    final estimatedBid = player.hand
        .where((card) => card.rank >= 12)
        .length;

    if (legalBids.contains(estimatedBid)) {
      return estimatedBid;
    }

    return legalBids.first;
  }

  void _submitLocalBid(int bid) {
    try {
      _turnTimer?.cancel();

      final result = BiddingEngine.submitBid(
        game: _game,
        bid: bid,
      );

      setState(() {
        _game = result.game;
      });

      if (result.biddingComplete) {
        _showMessage(
          'Bidding complete. Card play begins.',
        );
      }

      _continueAutomaticTurns();
    } on ArgumentError catch (error) {
      _showMessage(error.message.toString());
      _startTurnTimer();
    } on StateError catch (error) {
      _showMessage(error.message);
      _startTurnTimer();
    }
  }

  Future<void> _continueAiCardPlay() async {
    while (mounted &&
        _game.phase == GamePhase.playing &&
        _game.currentPlayer.isAi &&
        !_resolvingTrick) {
      _turnTimer?.cancel();

      await Future<void>.delayed(
        const Duration(milliseconds: 700),
      );

      if (!mounted ||
          _game.phase != GamePhase.playing ||
          !_game.currentPlayer.isAi) {
        return;
      }

      final legalCards =
          TrickEngine.legalCards(_game);

      final chosenCard =
          _chooseAiCard(legalCards);

      final result = TrickEngine.playCard(
        game: _game,
        card: chosenCard,
      );

      setState(() {
        _game = result.game;
      });

      if (result.trickComplete) {
        await _resolveTrick();
        return;
      }
    }

    if (mounted &&
        _game.phase == GamePhase.playing &&
        !_resolvingTrick) {
      _startTurnTimer();
    }
  }

  PlayingCard _chooseAiCard(
    List<PlayingCard> legalCards,
  ) {
    final sortedCards =
        List<PlayingCard>.from(legalCards)
          ..sort(
            (first, second) =>
                first.rank.compareTo(
              second.rank,
            ),
          );

    return sortedCards.first;
  }

  void _selectCard(PlayingCard card) {
    if (!_legalCards.contains(card)) {
      return;
    }

    setState(() {
      _selectedCard =
          _selectedCard == card
              ? null
              : card;
    });
  }

  Future<void> _playSelectedCard() async {
    final selectedCard = _selectedCard;

    if (selectedCard == null) {
      return;
    }

    try {
_turnTimer?.cancel();

setState(() {
  _isAnimatingCard = true;
  _animatingCard = selectedCard;
});

await Future<void>.delayed(
  const Duration(milliseconds: 350),
);

final result = TrickEngine.playCard(
  game: _game,
  card: selectedCard,
);

setState(() {
  _game = result.game;
  _selectedCard = null;
  _isAnimatingCard = false;
  _animatingCard = null;
});

await Future.delayed(
  const Duration(milliseconds: 350),
);
      if (result.trickComplete) {
        await _resolveTrick();
      } else {
        await _continueAiCardPlay();
      }
    } on ArgumentError catch (error) {
      _showMessage(error.message.toString());
      _startTurnTimer();
    } on StateError catch (error) {
      _showMessage(error.message);
      _startTurnTimer();
    }
  }

  Future<void> _resolveTrick() async {
    if (_resolvingTrick) {
      return;
    }

    _turnTimer?.cancel();

    final winnerIndex =
        TrickEngine.winnerIndex(_game);

    final winnerName =
        _game.players[winnerIndex].name;

    setState(() {
      _resolvingTrick = true;
    });

 setState(() {
  _trickWinnerName = winnerName;
});

await Future<void>.delayed(
  const Duration(seconds: 3),
);

    if (!mounted) {
      return;
    }

    setState(() {
      _game =
          TrickEngine.resolveCompletedTrick(
        _game,
      );

      _resolvingTrick = false;
      _selectedCard = null;
      _trickWinnerName = null;
    });

    if (_game.phase ==
        GamePhase.roundComplete) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              RoundResultsScreen(
            game: _game,
          ),
        ),
      );

      return;
    }

    await _continueAiCardPlay();
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color(0xFF0F3027),
  appBar: AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: const Color(0xFF0F3027),
    foregroundColor: const Color(0xFFF7F0DC),
    elevation: 0,
    title: Text(
      'Round ${_game.roundNumber} of 13',
      style: const TextStyle(
        fontWeight: FontWeight.w800,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(
          right: 18,
        ),
        child: Center(
          child: _TimerDisplay(
            seconds: _secondsRemaining,
            totalSeconds: _game.lobby.timerSeconds,
          ),
        ),
      ),
    ],
  ),
 body: SafeArea(
  child: Column(
    children: [
      _GameStatusBar(
        game: _game,
      ),

      const SizedBox(height: 12),

      OpponentStrip(
        players: _game.players.skip(1).toList(),
        currentPlayerId: _game.currentPlayer.id,
      ),

      const SizedBox(height: 12),

      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1D4A3C),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFF4D7868),
              ),
            ),
child: Stack(
  alignment: Alignment.center,
  children: [
    _showRoundOverlay
        ? RoundStartOverlay(
            game: _game,
            secondsRemaining: _roundCountdown,
          )
        : TableCentre(
            game: _game,
            isLocalPlayersTurn: _isLocalPlayersTurn,
            resolvingTrick: _resolvingTrick,
            trickWinnerName: _trickWinnerName,
            onBidConfirmed: _submitLocalBid,
          ),

    if (_isAnimatingCard && _animatingCard != null)
TweenAnimationBuilder<Offset>(
  tween: Tween(
    begin: const Offset(0, 1.4),
    end: Offset.zero,
  ),
  duration: const Duration(
    milliseconds: 350,
  ),
  curve: Curves.easeOutCubic,
  child: PlayingCardWidget(
    card: _animatingCard!,
    isPlayable: true,
    isSelected: true,
  ),
  builder: (
    context,
    offset,
    child,
  ) {
    return Transform.translate(
      offset: Offset(
        0,
        offset.dy * 170,
      ),
      child: child,
    );
  },
),
  ],
),
          ),
        ),
      ),

      const SizedBox(height: 12),

      _YourSeat(
        player: _localPlayer,
        isCurrentPlayer: _isLocalPlayersTurn,
      ),

      const SizedBox(height: 10),

      PlayerHand(
        cards: _localPlayer.hand,
        legalCards: _legalCards,
        selectedCard: _selectedCard,
        enabled:
            _game.phase == GamePhase.playing &&
            _isLocalPlayersTurn &&
            !_resolvingTrick,
        onCardSelected: _selectCard,
      ),

      const SizedBox(height: 12),

      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 58,
          child: FilledButton.icon(
            onPressed: _selectedCard == null
                ? null
                : _playSelectedCard,
            icon: const Icon(
              Icons.play_arrow_rounded,
            ),
            label: Text(
              _buttonLabel,
            ),
            style: FilledButton.styleFrom(
              backgroundColor:
                  const Color(0xFFE7D7A7),
              foregroundColor:
                  const Color(0xFF173B30),
              disabledBackgroundColor:
                  const Color(0x667D745E),
              disabledForegroundColor:
                  const Color(0xFFBEB6A3),
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),

      const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  String get _buttonLabel {
    if (_game.phase ==
        GamePhase.bidding) {
      return 'Complete Bidding First';
    }

    if (_game.phase ==
        GamePhase.roundComplete) {
      return 'Round Complete';
    }

    if (_resolvingTrick) {
      return 'Resolving Trick...';
    }

    if (!_isLocalPlayersTurn) {
      return 'Waiting for '
          '${_game.currentPlayer.name}';
    }

    if (_selectedCard == null) {
      return 'Select a Card';
    }

    return 'Play '
        '${_selectedCard!.rankLabel}'
        '${_selectedCard!.suitSymbol}';
  }
}

class _TimerDisplay extends StatelessWidget {
  const _TimerDisplay({
    required this.seconds,
    required this.totalSeconds,
  });

  final int seconds;
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    final progress =
        totalSeconds <= 0
            ? 0.0
            : seconds / totalSeconds;

    return Row(
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child:
              CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            backgroundColor:
                const Color(
              0x334F7567,
            ),
            color:
                const Color(
              0xFFE7D7A7,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${seconds}s',
          style: const TextStyle(
            color:
                Color(0xFFE7D7A7),
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ],
    );
  }
}




class _YourSeat
    extends StatelessWidget {
  const _YourSeat({
    required this.player,
    required this.isCurrentPlayer,
  });

  final Player player;
  final bool isCurrentPlayer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color:
            const Color(0xFFE7D7A7),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: isCurrentPlayer
              ? Colors.white
              : const Color(
                  0xFFE7D7A7,
                ),
          width:
              isCurrentPlayer ? 3 : 1,
        ),
      ),
      child: Text(
        '${player.name} • '
        'Bid ${player.bid ?? '-'} • '
        '${player.tricksWon} tricks',
        style: const TextStyle(
          color:
              Color(0xFF173B30),
          fontWeight:
              FontWeight.w900,
        ),
      ),
    );
  }
}



class _GameStatusBar
    extends StatelessWidget {
  const _GameStatusBar({
    required this.game,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatusPill(
              label:
                  '${game.cardsPerPlayer} cards',
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: _StatusPill(
              label:
                  game.trumpSuit == null
                      ? 'No Trump'
                      : _suitName(
                          game.trumpSuit!,
                        ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: _StatusPill(
              label:
                  'Dealer: ${game.dealer.name}',
            ),
          ),
        ],
      ),
    );
  }

  String _suitName(Suit suit) {
    switch (suit) {
      case Suit.diamonds:
        return 'Diamonds';
      case Suit.spades:
        return 'Spades';
      case Suit.hearts:
        return 'Hearts';
      case Suit.clubs:
        return 'Clubs';
    }
  }
}

class _StatusPill
    extends StatelessWidget {
  const _StatusPill({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      alignment:
          Alignment.center,
      decoration: BoxDecoration(
        color:
            const Color(0x332A5A49),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              const Color(0xFF456E5F),
        ),
      ),
      child: Text(
        label,
        overflow:
            TextOverflow.ellipsis,
        style: const TextStyle(
          color:
              Color(0xFFF7F0DC),
          fontSize: 12,
          fontWeight:
              FontWeight.w700,
        ),
      ),
    );
  }
}