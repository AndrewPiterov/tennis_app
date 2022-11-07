import 'package:equatable/equatable.dart';

class PlayerGame extends Equatable {
  const PlayerGame(this.firstPlayerScore, this.secondPlayerScore);

  final int firstPlayerScore;
  final int secondPlayerScore;

  @override
  List<Object?> get props => [firstPlayerScore, secondPlayerScore];
}
