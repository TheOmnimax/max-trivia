part of 'create_game_bloc.dart';

abstract class CreateGameEvent extends Equatable {
  const CreateGameEvent();

  @override
  List<Object?> get props => [];
}

// class ResetStatus extends CreateGameEvent {
//   const ResetStatus();
// }

class CreateGame extends CreateGameEvent {
  const CreateGame({
    required this.playerName,
    required this.numRounds,
    required this.categories,
  });

  final String playerName;
  final int numRounds;
  final List<String> categories;

  @override
  List<Object?> get props => [playerName, numRounds, categories];
}
