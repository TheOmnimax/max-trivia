part of 'create_game_bloc.dart';

abstract class CreateGameState extends Equatable {
  const CreateGameState({
    required this.playerName,
  });

  final String playerName;

  @override
  List<Object?> get props => [playerName];
}

class MainState extends CreateGameState {
  const MainState({
    required String playerName,
  }) : super(
          playerName: playerName,
        );
}

class CreatingState extends CreateGameState {
  const CreatingState({
    required String playerName,
  }) : super(
          playerName: playerName,
        );
}

class LoadingState extends CreateGameState {
  const LoadingState({
    required String playerName,
  }) : super(
          playerName: playerName,
        );
}
