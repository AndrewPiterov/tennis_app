import 'package:tennis_app/app/app.dart';

class PlayerGameRepository {
  final List<PlayerGame> _playerGames = [];

  void saveGame(PlayerGame game) {
    _playerGames.add(game);
  }
}
