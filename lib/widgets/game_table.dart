import 'package:flutter/material.dart';

class GameTable extends StatelessWidget {
  const GameTable({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.68,
        heightFactor: 0.72,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 260,
            maxHeight: 380,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF173B30),
            borderRadius: BorderRadius.circular(110),
            border: Border.all(
              color: const Color(0xFF5F8878),
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
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
                      borderRadius: BorderRadius.circular(92),
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
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0x22102D25),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: const Color(0x335F8878),
                    ),
                  ),
                ),
              ),

              child,
            ],
          ),
        ),
      ),
    );
  }
}