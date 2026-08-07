import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/game_engine.dart';
import '../models/lobby.dart';
import 'dealer_selection_screen.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({
    required this.lobbyName,
    required this.playerLimit,
    required this.timerSeconds,
    required this.isPrivate,
    super.key,
  });

  final String lobbyName;
  final int playerLimit;
  final int timerSeconds;
  final bool isPrivate;

  static const String lobbyCode = 'BLOB27';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF173B30),
      appBar: AppBar(
        title: const Text('Game Lobby'),
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

                Text(
                  lobbyName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Color(0xFFF7F0DC),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'LOBBY CODE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 2,
                    color: Color(0xFFD8D0BD),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x332A5A49),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE7D7A7),
                      width: 2,
                    ),
                  ),
                  child: const Text(
                    lobbyCode,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                      color: Color(0xFFE7D7A7),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  '1 / $playerLimit players connected',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFD8D0BD),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await Clipboard.setData(
                            const ClipboardData(
                              text: lobbyCode,
                            ),
                          );

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Lobby code copied: BLOB27',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text('Copy'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Sharing will be connected later.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.share_rounded),
                        label: const Text('Share'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                const Text(
                  'Players',
                  style: TextStyle(
                    color: Color(0xFFE7D7A7),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 12),

                const _PlayerTile(
                  name: 'Carl',
                  status: 'Host',
                  isHost: true,
                ),

                for (var seat = 2; seat <= playerLimit; seat++)
                  const _PlayerTile(
                    name: 'Waiting for player...',
                    status: 'Open seat',
                  ),

                const SizedBox(height: 28),

                _SettingsCard(
                  playerLimit: playerLimit,
                  timerSeconds: timerSeconds,
                  isPrivate: isPrivate,
                ),

                const SizedBox(height: 28),

                SizedBox(
                  height: 62,
                  child: FilledButton.icon(
                    onPressed: () {
                      final players =
                          GameEngine.createTemporaryPlayers(
                        playerLimit: playerLimit,
                      );

                      final lobby = Lobby(
                        id: 'local-lobby',
                        name: lobbyName,
                        code: lobbyCode,
                        playerLimit: playerLimit,
                        timerSeconds: timerSeconds,
                        isPrivate: isPrivate,
                        players: players,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DealerSelectionScreen(
                            lobby: lobby,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                    ),
                    label: const Text('Start Game'),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFE7D7A7),
                      foregroundColor:
                          const Color(0xFF173B30),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Temporary AI players are added for testing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFD8D0BD),
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

class _PlayerTile extends StatelessWidget {
  const _PlayerTile({
    required this.name,
    required this.status,
    this.isHost = false,
  });

  final String name;
  final String status;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0x332A5A49),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE7D7A7),
          foregroundColor: const Color(0xFF173B30),
          child: Icon(
            isHost
                ? Icons.workspace_premium_rounded
                : Icons.person_outline_rounded,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Color(0xFFF7F0DC),
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          status,
          style: const TextStyle(
            color: Color(0xFFD8D0BD),
          ),
        ),
        trailing: isHost
            ? const Text(
                'HOST',
                style: TextStyle(
                  color: Color(0xFFE7D7A7),
                  fontWeight: FontWeight.w900,
                ),
              )
            : null,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.playerLimit,
    required this.timerSeconds,
    required this.isPrivate,
  });

  final int playerLimit;
  final int timerSeconds;
  final bool isPrivate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0x332A5A49),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF456E5F),
        ),
      ),
      child: Column(
        children: [
          _SettingRow(
            label: 'Players',
            value: '$playerLimit',
          ),
          const Divider(),
          _SettingRow(
            label: 'Turn timer',
            value: '$timerSeconds seconds',
          ),
          const Divider(),
          _SettingRow(
            label: 'Game type',
            value: isPrivate ? 'Private' : 'Public',
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFD8D0BD),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF7F0DC),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}