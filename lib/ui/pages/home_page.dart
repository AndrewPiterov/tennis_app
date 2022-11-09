import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tennis_app/app/app.dart';
import 'package:tennis_app/ui/widgets/player_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GameSetService _setService = Get.find();
  final CurrentGameService _currentGameService = Get.find();

  late StreamSubscription<int> _winnerSubscription;
  late StreamSubscription<int> _setWinnerSubscription;

  @override
  void initState() {
    super.initState();

    _winnerSubscription = _currentGameService.winner$.listen((player) {
      if (player > 0) {
        Get.dialog(
          AlertDialog(
            title: const Text('Game Winner'),
            content: Text('Player #$player won the game'),
            actions: [
              TextButton(
                onPressed: () {
                  _currentGameService.completeGame();
                  Get.back();
                },
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    });

    _setWinnerSubscription = _setService.setWinner$.listen((event) {
      if (event > 0) {
        Get.dialog(
          AlertDialog(
            title: const Text('Set Winner'),
            content: Text('Player #$event won the set'),
            actions: [
              TextButton(
                onPressed: () {
                  // _setService.completeSet();
                  Get.back();
                },
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tennis App'),
      ),
      body: Row(
        children: [
          Expanded(
            child: PlayerView(
              playerId: 1,
              playerScore$: _currentGameService.player1Balls$,
              playerPlays$: _setService.games1$,
            ),
          ),
          Expanded(
            child: PlayerView(
              playerId: 2,
              playerScore$: _currentGameService.player2Balls$,
              playerPlays$: _setService.games2$,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _winnerSubscription.cancel();
    _setWinnerSubscription.cancel();

    super.dispose();
  }
}
