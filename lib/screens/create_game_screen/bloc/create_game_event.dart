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
    required this.numRounds,
    required this.categories,
  });

  final int numRounds;
  final List<String> categories;

  @override
  List<Object?> get props => [numRounds, categories];
}
