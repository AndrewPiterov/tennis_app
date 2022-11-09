import 'dart:developer';

import 'package:fluent_result/fluent_result.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:speed_up/speed_up.dart';
import 'package:tennis_app/app/app.dart';

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

  final _deuceSubject = BehaviorSubject.seeded(false);

  Stream<int> get winner$ =>
      CombineLatestStream.combine2<Tuple2<int, int>, bool, int>(
          _scoreSubject, _deuceSubject, (balls, isDeuce) {
        if (isDeuce) {
          if ((balls.item1 - balls.item2).abs() > 1) {
            return balls.item1 > balls.item2 ? 1 : 2;
          }
        } else {
          if (balls.item1 >= 4 || balls.item2 >= 4) {
            if ((balls.item1 - balls.item2).abs() > 1) {
              return balls.item1 > balls.item2 ? 1 : 2;
            }
          }
        }

        return -1;
      });

  Future hit(int player) async {
    final winner = await winner$.first;
    if (winner > 0) {
      log('Player $winner won the game');
      return;
    }

    final balls =
        player == 1 ? Tuple2(score1 + 1, score2) : Tuple2(score1, score2 + 1);

    final firstPlayerScore = AppConstants.scores[balls.item1];
    final secondPlayerScore = AppConstants.scores[balls.item2];
    if (firstPlayerScore == 40 && secondPlayerScore == 40) {
      _deuceSubject.add(true);
      log('Deuce');
      _scoreSubject.add(balls);
    } else if (firstPlayerScore == 100 && secondPlayerScore == 100) {
      _scoreSubject.add(Tuple2(3, 3));
    } else {
      _scoreSubject.add(balls);
    }
  }

  void completeGame() {
    _setService.saveSet(Tuple2(score1, score2));
    reset();
  }

  void reset() {
    _scoreSubject.add(Tuple2(0, 0));
    _deuceSubject.add(false);
  }

  Result start(String player1Name, String player2Name) {
    if (player1Name.isNullOrEmpty || player2Name.isNullOrEmpty) {
      return fail('Please enter player names');
    }
    _player1Name.value = player1Name;
    _player2Name.value = player2Name;

    _stateSubject.add(GameState.playing);
    return success();
  }
}
