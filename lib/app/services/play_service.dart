import 'package:get/get.dart';
import 'package:speed_up/speed_up.dart';

const _scores = [0, 15, 30, 40, 100];

class CurrentGameService {
  //
  final _balls = Tuple2<int, int>(0, 0).obs;
  Tuple2<int, int> get balls => _balls.value;

  Tuple2<int, int> get score =>
      Tuple2(_scores[balls.item1], _scores[balls.item2]);

  final _winner = 0.obs;
  int get winner => _winner.value;

  void hit(int player) {
    if (winner != 0) {
      throw Exception('Game is over');
    }

    if (player == 1) {
      _balls(balls.copyWith(item1: balls.item1 + 1));
    } else {
      _balls(balls.copyWith(item2: balls.item2 + 1));
    }

    if (balls.item1 - balls.item2 > 1) {
      _winner(1);
    } else if (balls.item2 - balls.item1 > 1) {
      _winner(2);
    }
  }
}
