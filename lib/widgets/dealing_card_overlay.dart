import 'package:flutter/material.dart';

class DealingCardOverlay extends StatelessWidget {
  const DealingCardOverlay({
    required this.visible,
    required this.destination,
    super.key,
  });

  final bool visible;
  final Alignment destination;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedAlign(
        duration: const Duration(
          milliseconds: 450,
        ),
        curve: Curves.easeInOutCubic,
        alignment:
            visible ? destination : Alignment.center,
        child: AnimatedOpacity(
          duration: const Duration(
            milliseconds: 200,
          ),
          opacity: visible ? 1 : 0,
          child: Container(
            width: 58,
            height: 78,
            decoration: BoxDecoration(
              color: const Color(0xFF173B30),
              borderRadius:
                  BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFE7D7A7),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
