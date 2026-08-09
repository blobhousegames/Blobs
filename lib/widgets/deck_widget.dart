import 'package:flutter/material.dart';

class DeckWidget extends StatelessWidget {
  const DeckWidget({
    this.width = 58,
    this.height = 78,
    super.key,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width + 8,
      height: height + 8,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 2,
            child: _CardBack(
              width: width,
              height: height,
              opacity: 0.45,
            ),
          ),
          Positioned(
            left: 4,
            top: 1,
            child: _CardBack(
              width: width,
              height: height,
              opacity: 0.7,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: _CardBack(
              width: width,
              height: height,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({
    required this.width,
    required this.height,
    this.opacity = 1,
  });

  final double width;
  final double height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF173B30),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFE7D7A7),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 7,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0x99E7D7A7),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.circle,
                size: 18,
                color: Color(0xFFE7D7A7),
              ),
            ),
          ),
        ),
      ),
    );
  }
}