import 'package:flutter/material.dart';

class BidSelector extends StatefulWidget {
  const BidSelector({
    required this.maximumBid,
    required this.onConfirmed,
    super.key,
  });

  final int maximumBid;
  final ValueChanged<int> onConfirmed;

  @override
  State<BidSelector> createState() => _BidSelectorState();
}

class _BidSelectorState extends State<BidSelector> {
  int selectedBid = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF173B30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE7D7A7),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'YOUR BID',
            style: TextStyle(
              color: Color(0xFFF7F0DC),
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: selectedBid > 0
                    ? () {
                        setState(() {
                          selectedBid--;
                        });
                      }
                    : null,
                icon: const Icon(Icons.remove_rounded),
              ),
              SizedBox(
                width: 86,
                child: Text(
                  '$selectedBid',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFE7D7A7),
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton.filledTonal(
                onPressed: selectedBid < widget.maximumBid
                    ? () {
                        setState(() {
                          selectedBid++;
                        });
                      }
                    : null,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: () {
                widget.onConfirmed(selectedBid);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE7D7A7),
                foregroundColor: const Color(0xFF173B30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Confirm Bid',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}