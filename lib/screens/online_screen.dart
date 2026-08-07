import 'package:flutter/material.dart';
import 'create_game_screen.dart';

class OnlineScreen extends StatelessWidget {
  const OnlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Online'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            const Text(
              'Play Blobs with friends or create a public game.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFD8D0C2),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              height: 62,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateGameScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create Game'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE7D7A7),
                  foregroundColor: const Color(0xFF173B30),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 62,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.search),
                label: const Text('Find Public Game'),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 62,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.group),
                label: const Text('Join with Room Code'),
              ),
            ),

            const Spacer(),

            SizedBox(
              height: 56,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}