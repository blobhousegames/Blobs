import 'package:flutter/material.dart';

class BlobAvatar extends StatelessWidget {
  const BlobAvatar({
    this.isActive = false,
    super.key,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      scale: isActive ? 1.08 : 1.0,
      child: Container(
        width: 58,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFE7D7A7),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(22),
            bottomRight: Radius.circular(26),
          ),
          border: Border.all(
            color: isActive
                ? const Color(0xFFF7F0DC)
                : const Color(0xFF668D7E),
            width: isActive ? 3 : 1.5,
          ),
          boxShadow: [
            if (isActive)
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned(
              left: 15,
              top: 18,
              child: _BlobEye(),
            ),
            const Positioned(
              right: 15,
              top: 18,
              child: _BlobEye(),
            ),
            Positioned(
              left: 21,
              bottom: 10,
              child: Container(
                width: 16,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF173B30),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlobEye extends StatelessWidget {
  const _BlobEye();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Color(0xFF173B30),
        shape: BoxShape.circle,
      ),
    );
  }
}