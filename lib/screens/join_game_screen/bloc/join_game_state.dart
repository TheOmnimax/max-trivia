part of 'join_game_bloc.dart';

abstract class JoinGameState extends Equatable {
  const JoinGameState({
    required this.joinStatus,
  });

  final JoinStatus joinStatus;

  @override
  List<Object?> get props => [joinStatus];

  JoinGameState copyWith();
}

class MainState extends JoinGameState {
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

class JoiningState extends JoinGameState {
  const JoiningState()
      : super(
          joinStatus: JoinStatus.none,
        );

  @override
  JoiningState copyWith() {
    return const JoiningState();
  }
}

class LoadingState extends JoinGameState {
  const LoadingState({
    required this.roomCode,
    required this.playerId,
    required this.playerName,
    required JoinStatus joinStatus,
  }) : super(
          joinStatus: joinStatus,
        );

  final String roomCode;
  final String playerId;
  final String playerName;

  @override
  LoadingState copyWith({
    String? roomCode,
    String? playerId,
    String? playerName,
    JoinStatus? joinStatus,
  }) {
    return LoadingState(
      roomCode: roomCode ?? this.roomCode,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      joinStatus: joinStatus ?? this.joinStatus,
    );
  }
}
