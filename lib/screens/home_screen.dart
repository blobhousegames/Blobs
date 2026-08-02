import 'package:flutter/material.dart';
import '../widgets/home_menu_button.dart';
import 'online_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: const Color(0xFF173B30),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.style,
                size: 80,
                color: Color(0xFFF7F0DC),
              ),
              const SizedBox(height: 24),
              const Text(
                'BLOBS',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7F0DC),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'by Blobhouse Games',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFE7D7A7),
                ),
              ),
              const SizedBox(height: 48),

              HomeMenuButton(
                label: 'Play Online',
                icon: Icons.public,
                isPrimary: true,
                onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const OnlineScreen(),
    ),
  );
},
              ),

              const SizedBox(height: 16),

              HomeMenuButton(
                label: 'Play with Friends',
                icon: Icons.group,
                onPressed: () {},
              ),

              const SizedBox(height: 16),

              HomeMenuButton(
                label: 'Play the Tutorial',
                icon: Icons.school,
                onPressed: () {},
              ),

              const SizedBox(height: 16),

              HomeMenuButton(
                label: 'Settings',
                icon: Icons.settings,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}