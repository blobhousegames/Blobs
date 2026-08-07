import '../models/player.dart';
import '../models/playing_card.dart';
import 'deck.dart';

class DealerSelectionDraw {
  const DealerSelectionDraw({
    required this.player,
    required this.card,
  });

  final Player player;
  final PlayingCard card;
}

class DealerSelectionResult {
  const DealerSelectionResult({
    required this.draws,
    required this.tiedPlayers,
    required this.dealer,
    required this.complete,
  });

  final List<DealerSelectionDraw> draws;
  final List<Player> tiedPlayers;
  final Player? dealer;
  final bool complete;
}

class DealerSelectionEngine {
  DealerSelectionEngine._();

  static DealerSelectionResult draw({
    required List<Player> players,
  }) {
    if (players.length < 2) {
      throw StateError(
        'At least two players are required for dealer selection.',
      );
    }

    final deck = Deck.shuffled();

    final draws = <DealerSelectionDraw>[
      for (var index = 0; index < players.length; index++)
        DealerSelectionDraw(
          player: players[index],
          card: deck[index],
        ),
    ];

    final highestRank = draws
        .map((draw) => draw.card.rank)
        .reduce(
          (first, second) =>
              first > second ? first : second,
        );

    final highestDraws = draws
        .where(
          (draw) => draw.card.rank == highestRank,
        )
        .toList();

    if (highestDraws.length == 1) {
      return DealerSelectionResult(
        draws: draws,
        tiedPlayers: const [],
        dealer: highestDraws.first.player,
        complete: true,
      );
    }

    return DealerSelectionResult(
      draws: draws,
      tiedPlayers: highestDraws
          .map((draw) => draw.player)
          .toList(),
      dealer: null,
      complete: false,
    );
  }
}