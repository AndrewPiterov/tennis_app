import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:speed_up/speed_up.dart';
import 'package:tennis_app/app/app.dart';

void main() {
  given('game', () {
    late CurrentGameService game;

    before(() {
      game = CurrentGameService();
    });

    then('scores should be 0:0', () {
      game.score.should.be(Tuple2(0, 0));
    });

    when('first player hits first time', () {
      before(() {
        game.hit(1);
      });

      then('score is 15:0', () {
        game.score.should.be(Tuple2(15, 0));
      });
    });

    when('first player hits twice', () {
      before(() {
        game.hit(1);
        game.hit(1);
      });

      then('score is 30:0', () {
        game.score.should.be(Tuple2(30, 0));
      });
    });

    when('first player hits three times', () {
      before(() {
        game.hit(1);
        game.hit(1);
        game.hit(1);
      });

      then('score is 40:0', () {
        game.score.should.be(Tuple2(40, 0));
      });
    });

    when('first player hits four times', () {
      before(() {
        game.hit(1);
        game.hit(1);
        game.hit(1);
        game.hit(1);
      });

      then('score is 100:0', () {
        game.score.should.be(Tuple2(100, 0));
      });
    });
  });
}
