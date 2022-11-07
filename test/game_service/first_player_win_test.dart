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

      and('second player hits first time', () {
        before(() {
          game.hit(2);
        });

        then('score is 15:15', () {
          game.score.should.be(Tuple2(15, 15));
        });

        and('first player hits two more', () {
          before(() {
            game.hit(1);
            game.hit(1);
          });

          then('score is 40:15', () {
            game.score.should.be(Tuple2(40, 15));
          }, and: {
            'first player is winner': () => game.winner.should.be(1),
          });

          when('player try to hit one more time', () {
            then('should throw exception', () {
              Should.throwException(() => game.hit(1));
            });
          });
        });
      });
    });
  });
}
