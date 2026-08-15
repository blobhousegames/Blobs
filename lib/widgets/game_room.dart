import 'package:flutter/material.dart';

class GameRoom extends StatelessWidget {
  const GameRoom({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF173B30),
            Color(0xFF0D2A22),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Window / outside view
          Positioned(
            top: 32,
            left: 32,
            child: Container(
              width: 190,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF9FC5D2),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE7D7A7),
                  width: 4,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF8EC7DD),
                              Color(0xFFD8E9D5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: Icon(
                        Icons.park_rounded,
                        size: 48,
                        color: Color(0xFF315C4D),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: IgnorePointer(
                      child: Row(
                        children: [
                          Expanded(child: SizedBox()),
                          Container(
                            width: 4,
                            color: Color(0xFFE7D7A7),
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floor
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFF684C36),
              ),
            ),
          ),

          // Main game content
          child,
        ],
      ),
    );
  }
}