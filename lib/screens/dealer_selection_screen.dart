import 'dart:async';

import 'package:flutter/material.dart';

import '../game/dealer_selection_engine.dart';
import '../game/game_engine.dart';
import '../models/lobby.dart';
import '../models/player.dart';
import '../models/playing_card.dart';
import 'table_screen.dart';

class DealerSelectionScreen extends StatefulWidget {
  const DealerSelectionScreen({
    required this.lobby,
    super.key,
  });

  final Lobby lobby;

  @override
  State<DealerSelectionScreen> createState() =>
      _DealerSelectionScreenState();
}

class _DealerSelectionScreenState
    extends State<DealerSelectionScreen> {
  late List<Player> _eligiblePlayers;

  DealerSelectionResult? _result;

  int _countdown = 3;
  bool _cardsRevealed = false;
  bool _countdownRunning = false;

  @override
  void initState() {
    super.initState();

    _eligiblePlayers =
        List<Player>.from(widget.lobby.players);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startDraw();
    });
  }

  Future<void> _startDraw() async {
    if (_countdownRunning) return;

    setState(() {
      _countdown = 3;
      _cardsRevealed = false;
      _countdownRunning = true;

      _result = DealerSelectionEngine.draw(
        players: _eligiblePlayers,
      );
    });

    for (var number = 3; number > 0; number--) {
      if (!mounted) return;

      setState(() {
        _countdown = number;
      });

      await Future<void>.delayed(
        const Duration(seconds: 1),
      );
    }

    if (!mounted) return;

    setState(() {
      _cardsRevealed = true;
      _countdownRunning = false;
    });
  }

  void _drawAgain() {
    final result = _result;

    if (result == null ||
        result.tiedPlayers.isEmpty) {
      return;
    }

    setState(() {
      _eligiblePlayers =
          List<Player>.from(result.tiedPlayers);
    });

    _startDraw();
  }

  void _beginGame() {
    final dealer = _result?.dealer;

    if (dealer == null) return;

    final dealerIndex =
        widget.lobby.players.indexWhere(
      (player) => player.id == dealer.id,
    );

    if (dealerIndex == -1) {
      throw StateError(
        'Selected dealer was not found in the lobby.',
      );
    }

    final game = GameEngine.createGame(
      lobby: widget.lobby,
      dealerIndex: dealerIndex,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TableScreen(
          game: game,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return Scaffold(
      backgroundColor: const Color(0xFF173B30),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Choose First Dealer',
        ),
        centerTitle: true,
        backgroundColor:
            const Color(0xFF173B30),
        foregroundColor:
            const Color(0xFFF7F0DC),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 700,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    'FIRST DEALER',
                    style: TextStyle(
                      color:
                          Color(0xFFF7F0DC),
                      fontSize: 30,
                      fontWeight:
                          FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _instructionText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color:
                          Color(0xFFD8D0BD),
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (!_cardsRevealed &&
                      result != null)
                    _CountdownDisplay(
                      countdown: _countdown,
                    ),

                  const SizedBox(height: 24),

                  if (result != null)
                    Expanded(
                      child: GridView.builder(
                        itemCount:
                            result.draws.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                              180,
                          mainAxisExtent:
                              210,
                          crossAxisSpacing:
                              18,
                          mainAxisSpacing:
                              18,
                        ),
                        itemBuilder:
                            (context, index) {
                          final draw =
                              result.draws[
                                  index];

                          return _DealerCard(
                            player:
                                draw.player,
                            card: draw.card,
                            revealed:
                                _cardsRevealed,
                            isWinner:
                                _cardsRevealed &&
                                    result
                                            .dealer
                                            ?.id ==
                                        draw.player
                                            .id,
                            isTied:
                                _cardsRevealed &&
                                    result
                                        .tiedPlayers
                                        .any(
                                      (player) =>
                                          player
                                              .id ==
                                          draw.player
                                              .id,
                                    ),
                          );
                        },
                      ),
                    ),

                  if (_cardsRevealed &&
                      result != null)
                    _BottomAction(
                      result: result,
                      onDrawAgain:
                          _drawAgain,
                      onBeginGame:
                          _beginGame,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get _instructionText {
    if (!_cardsRevealed) {
      return 'Cards reveal in $_countdown...';
    }

    final result = _result;

    if (result == null) {
      return '';
    }

    if (result.complete &&
        result.dealer != null) {
      return '${result.dealer!.name} is the first dealer.';
    }

    return 'Highest cards tied. Only those players draw again.';
  }
}

class _CountdownDisplay
    extends StatelessWidget {
  const _CountdownDisplay({
    required this.countdown,
  });

  final int countdown;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              const Color(0xFFE7D7A7),
          width: 2,
        ),
      ),
      child: Text(
        '$countdown',
        style: const TextStyle(
          color: Color(0xFFE7D7A7),
          fontSize: 34,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DealerCard extends StatelessWidget {
  const _DealerCard({
    required this.player,
    required this.card,
    required this.revealed,
    required this.isWinner,
    required this.isTied,
  });

  final Player player;
  final PlayingCard card;
  final bool revealed;
  final bool isWinner;
  final bool isTied;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          player.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFFF7F0DC),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 12),

        AnimatedSwitcher(
          duration:
              const Duration(
            milliseconds: 450,
          ),
          transitionBuilder:
              (child, animation) {
            return RotationTransition(
              turns: Tween<double>(
                begin: 0.5,
                end: 1,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: revealed
              ? _CardFront(
                  key: ValueKey(
                    '${player.id}-front',
                  ),
                  card: card,
                  highlighted:
                      isWinner || isTied,
                )
              : _CardBack(
                  key: ValueKey(
                    '${player.id}-back',
                  ),
                ),
        ),

        const SizedBox(height: 9),

        if (revealed && isWinner)
          const Text(
            'DEALER',
            style: TextStyle(
              color:
                  Color(0xFFE7D7A7),
              fontWeight:
                  FontWeight.w900,
              letterSpacing: 1.4,
            ),
          )
        else if (revealed && isTied)
          const Text(
            'TIED',
            style: TextStyle(
              color:
                  Color(0xFFE7D7A7),
              fontWeight:
                  FontWeight.w800,
            ),
          ),
      ],
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 130,
      decoration: BoxDecoration(
        color:
            const Color(0xFF173B30),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              const Color(0xFFE7D7A7),
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 58,
          height: 90,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              10,
            ),
            border: Border.all(
              color:
                  const Color(
                0xFFE7D7A7,
              ),
            ),
          ),
          child: const Text(
            'B',
            style: TextStyle(
              color:
                  Color(0xFFE7D7A7),
              fontSize: 36,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({
    required this.card,
    required this.highlighted,
    super.key,
  });

  final PlayingCard card;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 130,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:
            const Color(0xFFF8F3E6),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: highlighted
              ? const Color(
                  0xFFE7D7A7,
                )
              : const Color(
                  0xFFAAA394,
                ),
          width: highlighted ? 3 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          '${card.rankLabel}'
          '${card.suitSymbol}',
          style: TextStyle(
            color: card.isRed
                ? const Color(
                    0xFFB63C3C,
                  )
                : const Color(
                    0xFF17201D,
                  ),
            fontSize: 25,
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _BottomAction
    extends StatelessWidget {
  const _BottomAction({
    required this.result,
    required this.onDrawAgain,
    required this.onBeginGame,
  });

  final DealerSelectionResult result;
  final VoidCallback onDrawAgain;
  final VoidCallback onBeginGame;

  @override
  Widget build(BuildContext context) {
    final selectionComplete =
        result.complete &&
            result.dealer != null;

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: FilledButton.icon(
        onPressed: selectionComplete
            ? onBeginGame
            : onDrawAgain,
        icon: Icon(
          selectionComplete
              ? Icons
                  .play_arrow_rounded
              : Icons
                  .refresh_rounded,
        ),
        label: Text(
          selectionComplete
              ? 'Begin Round 1'
              : 'Draw Again',
        ),
        style:
            FilledButton.styleFrom(
          backgroundColor:
              const Color(
            0xFFE7D7A7,
          ),
          foregroundColor:
              const Color(
            0xFF173B30,
          ),
          textStyle:
              const TextStyle(
            fontSize: 17,
            fontWeight:
                FontWeight.w900,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
        ),
      ),
    );
  }
}