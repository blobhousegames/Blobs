import 'package:flutter/material.dart';

import '../models/playing_card.dart';
import 'playing_card_widget.dart';

import 'dart:async';



class PlayerHand extends StatefulWidget {
  const PlayerHand({
    required this.cards,
    required this.legalCards,
    required this.selectedCard,
    required this.enabled,
    required this.onCardSelected,
    super.key,
  });

  final List<PlayingCard> cards;
  final List<PlayingCard> legalCards;
  final PlayingCard? selectedCard;
  final bool enabled;
  final ValueChanged<PlayingCard> onCardSelected;

  @override
  State<PlayerHand> createState() => _PlayerHandState();
}

class _PlayerHandState extends State<PlayerHand> {
  Timer? _dealTimer;
  int _visibleCardCount = 0;

  @override
  void initState() {
    super.initState();
    _startDealAnimation();
  }

  @override
  void didUpdateWidget(covariant PlayerHand oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cards.length != widget.cards.length &&
        widget.cards.length > oldWidget.cards.length) {
      _startDealAnimation();
    }
  }

  @override
  void dispose() {
    _dealTimer?.cancel();
    super.dispose();
  }

  void _startDealAnimation() {
    _dealTimer?.cancel();

    _visibleCardCount = 0;

    if (widget.cards.isEmpty) {
      return;
    }

    _dealTimer = Timer.periodic(
      const Duration(milliseconds: 120),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_visibleCardCount >= widget.cards.length) {
          timer.cancel();
          return;
        }

        setState(() {
          _visibleCardCount++;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 122,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: widget.cards.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final card = widget.cards[index];

          final isLegal =
              widget.enabled &&
              widget.legalCards.contains(card);

          final isVisible =
              index < _visibleCardCount;

          return AnimatedOpacity(
            duration: const Duration(
              milliseconds: 180,
            ),
            opacity: isVisible ? 1 : 0,
            child: AnimatedSlide(
              duration: const Duration(
                milliseconds: 220,
              ),
              curve: Curves.easeOutCubic,
              offset: isVisible
                  ? Offset.zero
                  : const Offset(0, 0.7),
              child: IgnorePointer(
                ignoring: !isVisible,
                child: GestureDetector(
                  onTap: isLegal
                      ? () => widget.onCardSelected(card)
                      : null,
                  child: PlayingCardWidget(
                    card: card,
                    isPlayable: isLegal,
                    isSelected:
                        widget.selectedCard == card,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}