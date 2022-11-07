import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'player_view_controller.dart';

import 'package:speed_up_get/speed_up_get.dart';

class PlayerView extends GetWidget<PlayerViewController> {
  const PlayerView(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Obx(
            () => Center(
              child: Text(c.playerName),
            ),
          ),
          const Expanded(child: Text('plays')),
          Obx(
            () => Text(c.playerScore.toString()),
          ),
          ElevatedButton(
            onPressed: c.hitBall,
            child: const Text('Hit a Ball'),
          ),
        ],
      ),
    );
  }
}
