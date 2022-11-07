import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

final hitScores = [0, 15, 30, 40];

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

class PlayerViewController extends GetxController {
  //
  late FormGroup form;

  @override
  void onInit() {
    super.onInit();

    form = FormGroup({
      'playerName': FormControl<String>(value: 'Player'),
    });
  }

  final _playerName = ''.obs;
  String get playerName => _playerName.value;

  final _playerScore = 0.obs;
  int get playerScore => _playerScore.value;

  void hitBall() {
    _playerScore.value++;
  }
}
