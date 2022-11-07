import 'package:get/get.dart';

import 'widgets/player_view_controller.dart';

Future initUI() async {
  Get.create(() => PlayerViewController());
}
