import 'package:get/get.dart';
import 'package:tennis_app/app/repositories/player_games_repository.dart';
import 'package:tennis_app/app/services/play_service.dart';

export './models/player_game.dart';
export './repositories/player_games_repository.dart';
export './services/play_service.dart';

Future initApp() async {
  Get.put(PlayerGameRepository());
  Get.put(CurrentGameService());
}
