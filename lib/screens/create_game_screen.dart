import 'package:flutter/material.dart';
import 'lobby_screen.dart';
class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final TextEditingController _lobbyNameController =
      TextEditingController(text: 'Blobhouse Lobby');

  int _selectedPlayers = 4;
  int _selectedTimer = 30;
  bool _isPrivate = true;

  @override
  void dispose() {
    _lobbyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF173B30),
      appBar: AppBar(
        title: const Text('Create Game'),
        backgroundColor: const Color(0xFF173B30),
        foregroundColor: const Color(0xFFF7F0DC),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 12),
                const Text(
                  'CREATE GAME',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Color(0xFFF7F0DC),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose how you want to play.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFD8D0BD),
                  ),
                ),
                const SizedBox(height: 32),

                const _SectionTitle('Lobby name'),
                const SizedBox(height: 12),
                TextField(
                  controller: _lobbyNameController,
                  style: const TextStyle(
                    color: Color(0xFFF7F0DC),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0x332A5A49),
                    hintText: 'Enter lobby name',
                    hintStyle: const TextStyle(
                      color: Color(0xFFAAA18E),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF6E8D80),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF6E8D80),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFE7D7A7),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),
                const _SectionTitle('Players'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final playerCount in [3, 4, 5, 6, 7])
                      ChoiceChip(
                        label: Text('$playerCount'),
                        selected: _selectedPlayers == playerCount,
                        onSelected: (_) {
                          setState(() {
                            _selectedPlayers = playerCount;
                          });
                        },
                      ),
                  ],
                ),

                const SizedBox(height: 28),
                const _SectionTitle('Turn timer'),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: _selectedTimer,
                  dropdownColor: const Color(0xFF234C3D),
                  style: const TextStyle(
                    color: Color(0xFFF7F0DC),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0x332A5A49),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF6E8D80),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF6E8D80),
                      ),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 15,
                      child: Text('15 seconds'),
                    ),
                    DropdownMenuItem(
                      value: 30,
                      child: Text('30 seconds'),
                    ),
                    DropdownMenuItem(
                      value: 45,
                      child: Text('45 seconds'),
                    ),
                    DropdownMenuItem(
                      value: 60,
                      child: Text('60 seconds'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _selectedTimer = value;
                    });
                  },
                ),

                const SizedBox(height: 28),
                const _SectionTitle('Game type'),
                const SizedBox(height: 12),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('Private'),
                      icon: Icon(Icons.lock_rounded),
                    ),
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('Public'),
                      icon: Icon(Icons.public_rounded),
                    ),
                  ],
                  selected: {_isPrivate},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _isPrivate = selection.first;
                    });
                  },
                ),

                const SizedBox(height: 40),
                SizedBox(
                  height: 62,
                  child: FilledButton.icon(
              onPressed: () {
  final lobbyName = _lobbyNameController.text.trim().isEmpty
      ? 'Blobhouse Lobby'
      : _lobbyNameController.text.trim();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LobbyScreen(
        lobbyName: lobbyName,
        playerLimit: _selectedPlayers,
        timerSeconds: _selectedTimer,
        isPrivate: _isPrivate,
      ),
    ),
  );
},
                    icon: const Icon(Icons.meeting_room_rounded),
                    label: const Text('Create Lobby'),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFFE7D7A7),
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}