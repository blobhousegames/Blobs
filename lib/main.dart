import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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