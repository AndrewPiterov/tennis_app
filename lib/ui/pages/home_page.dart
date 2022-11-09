import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:speed_up_flutter/speed_up_flutter.dart';
import 'package:tennis_app/app/app.dart';
import 'package:tennis_app/ui/text_formatters/player_name_formatter.dart';
import 'package:tennis_app/ui/pages/widgets/player_view.dart';
import 'package:tennis_app/ui/widgets/submit_button.dart';

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

  late FormGroup _form;

  @override
  void initState() {
    super.initState();

    const regexp = r'^\w{3,} \w{3,}$';

    _form = fb.group({
      'player1Name': [
        Validators.required,
        Validators.minLength(3),
        Validators.maxLength(25),
        Validators.pattern(regexp),
      ],
      'player2Name': [
        Validators.required,
        Validators.minLength(3),
        Validators.maxLength(25),
        Validators.pattern(regexp),
      ],
    });

    _winnerSubscription = _currentGameService.winner$.listen((player) {
      if (player > 0) {
        final playerName = player == 1
            ? _currentGameService.player1Name
            : _currentGameService.player2Name;
        Get.dialog(
          AlertDialog(
            title: const Text('Game Winner'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Player #$player $playerName won the game'),
                10.h,
                const Text(
                  '🎉',
                  style: TextStyle(fontSize: 60),
                ),
              ],
            ),
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Player #$player $playerName won the set'),
                10.h,
                const Text(
                  '🎉🎉🎉',
                  style: TextStyle(fontSize: 60),
                ),
              ],
            ),
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
      body: ReactiveForm(
        formGroup: _form,
        child: StreamBuilder<GameState>(
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
                            child: ReactiveTextField(
                              formControlName: 'player1Name',
                              // onChanged: _currentGameService.onPlayer1NameChanged,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Player #1 Name',
                              ),
                              inputFormatters: [
                                PlayerNameFormatter(),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ReactiveTextField(
                              formControlName: 'player2Name',
                              // onChanged: _currentGameService.onPlayer2NameChanged,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Player #2 Name',
                              ),
                              inputFormatters: [
                                PlayerNameFormatter(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: SubmitButton(
                          child: const Text('Start Game'),
                          onTap: () => _currentGameService.start(
                            _form.control('player1Name').value!.toString(),
                            _form.control('player2Name').value!.toString(),
                          ),
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
