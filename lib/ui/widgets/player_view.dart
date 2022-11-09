import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_up/speed_up.dart';
import 'package:speed_up_flutter/speed_up_flutter.dart';
import 'package:tennis_app/app/app.dart';

/*
 Счет увеличивается по стандартным правилам тенниса 0 – 15 – 30 – 40 – Победа в гейме. 
 
 Если счет 40 – 40, то для победы необходимо выиграть 2 мяча. 
 При выигрыше первого мяча у выигравшего мяч счет меняется с 40 на A. 
 Если после этого другой игрок выиграл мяч, то счет становится снова 40:40. 
 При победе в гейме счет обоих игроков в текущем гейме сбрасывается на 0:0,
а счетчик выигранных геймов у победителя увеличивается.

 Если победитель выиграл 6 геймов или более с разнией 2 и более (6:0, 6:1, 6:2, 6:3, 6:4, 7:5, 8:6 и т.д.) 
 – возникает всплывающее сообщение о победе соответсвующего игрока в сете..

*/

class PlayerView extends StatelessWidget {
  PlayerView({
    required this.playerId,
    required this.playerScore$,
    required this.playerPlays$,
    super.key,
  });

  final CurrentGameService _currentGameService = Get.find();

  final int playerId;
  final Stream<int> playerScore$;
  final Stream<List<Tuple2<int, int>>> playerPlays$;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          20.h,
          Center(
            child: Text(
              'Player #$playerId',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          40.h,
          Expanded(
            child: StreamBuilder(
              stream: playerPlays$,
              builder: ((context, snapshot) {
                final games = snapshot.data ?? [];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: games
                      .map(
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
                      )
                      .toList(),
                );
              }),
            ),
          ),
          40.h,
          StreamBuilder<int>(
            stream: playerScore$,
            initialData: 0,
            builder: ((_, snapshot) {
              final data = snapshot.data;
              return Text(
                data.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ),
          40.h,
          ElevatedButton(
            onPressed: _hitBall,
            child: const Text('Hit a Ball'),
          ),
        ],
      ),
    );
  }

  void _hitBall() {
    _currentGameService.hit(playerId);
  }
}
