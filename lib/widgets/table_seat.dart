import 'package:flutter/material.dart';

class TableSeat extends StatelessWidget {
  const TableSeat({
    required this.alignment,
    required this.offset,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    super.key,
  });

  final Alignment alignment;
  final Offset offset;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: padding,
        child: Align(
          alignment: alignment,
          child: Transform.translate(
            offset: offset,
            child: child,
          ),
        ),
      ),
    );
  }
}