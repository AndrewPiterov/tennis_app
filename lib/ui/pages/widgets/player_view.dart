import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_up/speed_up.dart';
import 'package:speed_up_flutter/speed_up_flutter.dart';
import 'package:tennis_app/app/app.dart';
import 'package:tennis_app/ui/gen/assets.gen.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({
    required this.playerId,
    required this.playerScore$,
    required this.playerPlays$,
    super.key,
  });

  final int playerId;
  final Stream<int> playerScore$;
  final Stream<List<Tuple2<int, int>>> playerPlays$;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  final CurrentGameService _currentGameService = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          20.h,
          Center(
            child: Obx(
              () => Text(
                widget.playerId == 1
                    ? _currentGameService.player1Name
                    : _currentGameService.player2Name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: widget.playerPlays$,
              builder: ((context, snapshot) {
                final games = snapshot.data ?? [];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...games.map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${e.item1}:${e.item2}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    20.h,
                    StreamBuilder<int>(
                      stream: widget.playerScore$,
                      initialData: 0,
                      builder: ((_, snapshot) {
                        final balls = snapshot.data!;
                        final title =
                            balls > 3 ? 'A' : '${AppConstants.scores[balls]}';
                        return Text(
                          title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                    ),
                  ],
                );
              }),
            ),
          ),
          InkWell(
            onTap: _hitBall,
            child: Assets.images.tennisBall.image(
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          30.h,
        ],
      ),
    );
  }

  void _hitBall() {
    _currentGameService.hit(widget.playerId);
  }
}
