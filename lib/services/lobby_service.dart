import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LobbyService {
  LobbyService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static const String _characters = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  String _generateRoomCode() {
    final random = Random.secure();

    return List.generate(
      6,
      (_) => _characters[random.nextInt(_characters.length)],
    ).join();
  }

  Future<String> createLobby({
    required String playerName,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError(
        'A player must be signed in before creating a lobby.',
      );
    }

    for (var attempt = 0; attempt < 10; attempt++) {
      final roomCode = _generateRoomCode();

      final lobbyReference = _firestore
          .collection('lobbies')
          .doc(roomCode);

      final existingLobby = await lobbyReference.get();

      if (existingLobby.exists) {
        continue;
      }

      await lobbyReference.set({
        'roomCode': roomCode,
        'hostId': user.uid,
        'status': 'waiting',
        'createdAt': FieldValue.serverTimestamp(),
        'players': [
          {
            'id': user.uid,
            'name': playerName,
            'isHost': true,
          },
        ],
      });

      return roomCode;
    }

    throw StateError(
      'Unable to generate a unique room code.',
    );
  }
}