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
          seedColor: const Color(0xFF234C3D),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF173B30),
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
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E4A3B),
                Color(0xFF102D25),
              ],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Column(
                  children: [
                    const Spacer(),

                    Container(
                      width: 116,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F5E8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFD7C89A),
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'B',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF234C3D),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),

                    const Text(
                      'BLOBS',
                      style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 7,
                        color: Color(0xFFF7F0DC),
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'The trick-taking card game',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFD8D0BD),
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'by Blobhouse Games',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFBDB49F),
                      ),
                    ),

                    const SizedBox(height: 42),

                    HomeMenuButton(
                      label: 'Play Online',
                      icon: Icons.public_rounded,
                      isPrimary: true,
                      onPressed: () {},
                    ),

                    const SizedBox(height: 14),

                    HomeMenuButton(
                      label: 'Play with Friends',
                      icon: Icons.groups_rounded,
                      onPressed: () {},
                    ),

                    const SizedBox(height: 14),

                    HomeMenuButton(
                      label: 'Play the Tutorial',
                      icon: Icons.school_rounded,
                      onPressed: () {},
                    ),

                    const SizedBox(height: 14),

                    HomeMenuButton(
                      label: 'Settings',
                      icon: Icons.settings_rounded,
                      onPressed: () {},
                    ),

                    const Spacer(),

                    const Text(
                      'Version 0.1.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFAAA18E),
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      '© Blobhouse Games',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFAAA18E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeMenuButton extends StatelessWidget {
  const HomeMenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: isPrimary
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE7D7A7),
                foregroundColor: const Color(0xFF173B30),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFF7F0DC),
                backgroundColor: const Color(0x332A5A49),
                side: const BorderSide(
                  color: Color(0xFF6E8D80),
                ),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
    );
  }
}