import 'package:flutter/material.dart';

void main() {
  runApp(const BlobsApp());
}

class BlobsApp extends StatelessWidget {
  const BlobsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blobs',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'BLOBS',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A Blobhouse Games card game',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  HomeButton(
                    label: 'Play Online',
                    icon: Icons.public,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 14),
                  HomeButton(
                    label: 'Play with Friends',
                    icon: Icons.groups,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 14),
                  HomeButton(
                    label: 'Play the Tutorial',
                    icon: Icons.school,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 14),
                  HomeButton(
                    label: 'Settings',
                    icon: Icons.settings,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
