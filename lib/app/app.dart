import 'package:get/get.dart';
import 'package:tennis_app/app/services/current_game_service.dart';

import 'services/game_set_service.dart';

export './constants.dart';
export 'services/current_game_service.dart';
export 'services/game_set_service.dart';

Future initApp() async {
  Get.put(GameSetService());
  Get.put(CurrentGameService());
}
