import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_up_flutter/speed_up_flutter.dart';
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
        final playerName = player == 1
            ? _currentGameService.player1Name
            : _currentGameService.player2Name;
        Get.dialog(
          AlertDialog(
            title: const Text('Game Winner'),
            content: Text('Player #$playerName won the game'),
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

    _setWinnerSubscription = _setService.setWinner$.listen((player) {
      if (player > 0) {
        final playerName = player == 1
            ? _currentGameService.player1Name
            : _currentGameService.player2Name;
        Get.dialog(
          AlertDialog(
            title: const Text('Set Winner'),
            content: Text('Player #$playerName won the set'),
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
      body: StreamBuilder<GameState>(
          stream: _currentGameService.state$,
          initialData: GameState.idle,
          builder: (context, snapshot) {
            final gameState = snapshot.data!;

            if (gameState == GameState.idle) {
              return Column(
                children: [
                  20.h,
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: _currentGameService.onPlayer1NameChanged,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Player #1 Name',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: _currentGameService.onPlayer2NameChanged,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Player #2 Name',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          final res = _currentGameService.start();
                          if (res.isFail) {
                            Get.snackbar(
                              'Warning',
                              res.errorMessage,
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: const Text('Start Game'),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Row(
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
            );
          }),
    );
  }

  @override
  void dispose() {
    _winnerSubscription.cancel();
    _setWinnerSubscription.cancel();

    super.dispose();
  }
}
