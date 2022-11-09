import 'dart:developer';

import 'package:fluent_result/fluent_result.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:speed_up/speed_up.dart';
import 'package:tennis_app/app/app.dart';

const _scores = [0, 15, 30, 40, 100];

enum GameState { idle, playing, completed }

class CurrentGameService {
  final GameSetService _setService = Get.find();

  final _stateSubject = BehaviorSubject.seeded(GameState.idle);
  Stream<GameState> get state$ => _stateSubject.stream;

  final _scoreSubject = BehaviorSubject.seeded(Tuple2(0, 0));

  Stream<int> get player1Balls$ =>
      _scoreSubject.distinct().map((event) => event.item1);
  Stream<int> get player2Balls$ =>
      _scoreSubject.distinct().map((event) => event.item2);

  int get score1 => _scoreSubject.value.item1;
  int get score2 => _scoreSubject.value.item2;

  final _player1Name = ''.obs;
  String get player1Name => _player1Name.value;

  final _player2Name = ''.obs;
  String get player2Name => _player2Name.value;

  Stream<int> get winner$ => _scoreSubject.map(
        (event) {
          if ((event.item1 - event.item2).abs() > 1) {
            return event.item1 > event.item2 ? 1 : 2;
          }

          return -1;
        },
      );

  Future hit(int player) async {
    final winner = await winner$.first;
    if (winner > 0) {
      log('Player $winner won the game');
      return;
    }

    if (player == 1) {
      _scoreSubject.add(Tuple2(score1 + 1, score2));
    } else {
      _scoreSubject.add(Tuple2(score1, score2 + 1));
    }
  }

  void completeGame() {
    _setService.saveSet(Tuple2(score1, score2));
    reset();
  }

  void reset() {
    _scoreSubject.add(Tuple2(0, 0));
  }

  void onPlayer1NameChanged(String value) {
    _player1Name.value = value;
  }

  void onPlayer2NameChanged(String value) {
    _player2Name.value = value;
  }

  Result start() {
    if (player1Name.isNullOrEmpty || player2Name.isNullOrEmpty) {
      return fail('Please enter player names');
    }

    _stateSubject.add(GameState.playing);
    return success();
  }
}
