import 'package:speed_up/speed_up.dart';

class PlayerGameRepository {
  final List<Tuple2<int, int>> _playerGames = [];

  List<Tuple2<int, int>> getPlayerGame(int playerId) {
    if (playerId == 2) {
      return _playerGames.map((e) => Tuple2(e.item2, e.item1)).toList();
    }
    return _playerGames.toList();
  }

  void saveGame(Tuple2<int, int> game) {
    _playerGames.add(game);
  }
}
