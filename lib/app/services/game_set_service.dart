import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:speed_up/speed_up.dart';

class GameSetService extends GetxController {
  final _gamesSubject = BehaviorSubject.seeded(<Tuple2<int, int>>[]);
  List<Tuple2<int, int>> get games => _gamesSubject.value;

  Stream<List<Tuple2<int, int>>> get games$ => _gamesSubject.distinct();

  Stream<List<Tuple2<int, int>>> get games1$ => _gamesSubject.distinct();
  Stream<List<Tuple2<int, int>>> get games2$ => _gamesSubject
      .map((event) => event.map((e) => Tuple2(e.item2, e.item1)).toList())
      .distinct();

  Stream<int> get setWinner$ => _gamesSubject.map((event) {
        final arr1 = games.map((e) => (e.item1 - e.item2) > 1 ? 1 : 0).toList();
        final arr2 = games.map((e) => (e.item2 - e.item1) > 1 ? 1 : 0).toList();

        final sum1 = arr1.sum();
        final sum2 = arr2.sum();

        if (sum1 > 5) {
          return 1;
        } else if (sum2 > 5) {
          return 2;
        }

        return -1;
      }).distinct();

  void saveSet(Tuple2<int, int> game) {
    _gamesSubject.add([...games, game]);
  }
}
