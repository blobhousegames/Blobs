import 'package:flutter/material.dart';

class GameTable extends StatelessWidget {
  const GameTable({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 300,
        maxHeight: 430,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF173B30),
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          color: const Color(0xFF5F8878),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Inner table rail
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(72),
                  border: Border.all(
                    color: const Color(0x445F8878),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          // Protected centre play zone
          Center(
            child: Container(
              width: 280,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0x22102D25),
                borderRadius:
                    BorderRadius.circular(36),
                border: Border.all(
                  color: const Color(0x335F8878),
                ),
              ),
            ),
          ),

          child,
        ],
      ),
    );
  }
}