part of 'create_game_bloc.dart';

abstract class CreateGameEvent extends Equatable {
  const CreateGameEvent();

  @override
  List<Object?> get props => [];
}

class UpdateName extends CreateGameEvent {
  const UpdateName({
    required this.playerName,
  });

  final String playerName;

  @override
  List<Object?> get props => [playerName];
}

// class CreateRoom extends CreateGameEvent {
//   const CreateRoom();
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
