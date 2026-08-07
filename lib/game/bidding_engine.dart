import '../models/game.dart';
import '../models/player.dart';

class BidResult {
  const BidResult({
    required this.game,
    required this.biddingComplete,
  });

  final Game game;
  final bool biddingComplete;
}

class BiddingEngine {
  BiddingEngine._();

  static List<int> legalBids(Game game) {
    final maximumBid = game.cardsPerPlayer;
    final isDealer = game.currentPlayerIndex == game.dealerIndex;

    final bids = [
      for (var bid = 0; bid <= maximumBid; bid++) bid,
    ];

    if (!isDealer) {
      return bids;
    }

    final submittedBidTotal = game.players
        .where((player) => player.bid != null)
        .fold<int>(
          0,
          (total, player) => total + player.bid!,
        );

    final forbiddenDealerBid =
        game.cardsPerPlayer - submittedBidTotal;

    return bids
        .where((bid) => bid != forbiddenDealerBid)
        .toList();
  }

  static BidResult submitBid({
    required Game game,
    required int bid,
  }) {
    if (game.phase != GamePhase.bidding) {
      throw StateError(
        'Bids can only be submitted during the bidding phase.',
      );
    }

    final currentPlayer = game.currentPlayer;

    if (currentPlayer.bid != null) {
      throw StateError(
        '${currentPlayer.name} has already submitted a bid.',
      );
    }

    final legalBids = BiddingEngine.legalBids(game);

    if (!legalBids.contains(bid)) {
      throw ArgumentError(
        'Bid $bid is not legal for ${currentPlayer.name}.',
      );
    }

    final updatedPlayers = List<Player>.from(game.players);

    updatedPlayers[game.currentPlayerIndex] =
        currentPlayer.copyWith(
      bid: bid,
    );

    final biddingComplete = updatedPlayers.every(
      (player) => player.bid != null,
    );

    if (biddingComplete) {
      final firstPlayerIndex =
          (game.dealerIndex + 1) % updatedPlayers.length;

      return BidResult(
        game: game.copyWith(
          players: updatedPlayers,
          lobby: game.lobby.copyWith(
            players: updatedPlayers,
          ),
          currentPlayerIndex: firstPlayerIndex,
          phase: GamePhase.playing,
        ),
        biddingComplete: true,
      );
    }

    final nextPlayerIndex = _nextPlayerWithoutBid(
      players: updatedPlayers,
      startingAfter: game.currentPlayerIndex,
    );

    return BidResult(
      game: game.copyWith(
        players: updatedPlayers,
        lobby: game.lobby.copyWith(
          players: updatedPlayers,
        ),
        currentPlayerIndex: nextPlayerIndex,
      ),
      biddingComplete: false,
    );
  }

  static int _nextPlayerWithoutBid({
    required List<Player> players,
    required int startingAfter,
  }) {
    for (var offset = 1; offset <= players.length; offset++) {
      final index = (startingAfter + offset) % players.length;

      if (players[index].bid == null) {
        return index;
      }
    }

    throw StateError('No player is waiting to bid.');
  }
}