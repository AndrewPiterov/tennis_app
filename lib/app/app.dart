import 'package:get/get.dart';
import 'package:tennis_app/app/repositories/player_games_repository.dart';
import 'package:tennis_app/app/services/current_game_service.dart';

import 'services/game_set_service.dart';

export './models/player_game.dart';
export './repositories/player_games_repository.dart';
export 'services/current_game_service.dart';
export 'services/game_set_service.dart';

Future initApp() async {
  Get.put(PlayerGameRepository());
  Get.put(GameSetService());
  Get.put(CurrentGameService());
}
