part of 'create_game_bloc.dart';

abstract class CreateGameState extends Equatable {
  const CreateGameState({
    required this.joinStatus,
  });

  final JoinStatus joinStatus;

  @override
  List<Object?> get props => [
        joinStatus,
      ];

  CreateGameState copyWith({
    JoinStatus? joinStatus,
  });
}

class MainState extends CreateGameState {
  const MainState({
    required JoinStatus joinStatus,
  }) : super(
          joinStatus: joinStatus,
        );

  @override
  MainState copyWith({
    JoinStatus? joinStatus,
  }) {
    return MainState(
      joinStatus: joinStatus ?? this.joinStatus,
    );
  }
}

class CreatingState extends CreateGameState {
  const CreatingState()
      : super(
          joinStatus: JoinStatus.none,
        );

  @override
  CreatingState copyWith({
    JoinStatus? joinStatus,
  }) {
    return CreatingState();
  }
}

class LoadingState extends CreateGameState {
  const LoadingState()
      : super(
          joinStatus: JoinStatus.none,
        );

  @override
  LoadingState copyWith({
    JoinStatus? joinStatus,
  }) {
    return LoadingState();
  }
}
