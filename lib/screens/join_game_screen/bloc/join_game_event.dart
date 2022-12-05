part of 'join_game_bloc.dart';

abstract class JoinGameEvent extends Equatable {
  const JoinGameEvent();

  @override
  List<Object?> get props => [];
}

class JoinGame extends JoinGameEvent {
  const JoinGame({
    required this.name,
    required this.roomCode,
  });

  final String name;
  final String roomCode;

  @override
  List<Object?> get props => [
        name,
        roomCode,
      ];
}

class JoinError extends JoinGameEvent {
  const JoinError({
    required this.joinStatus,
  });

  final JoinStatus joinStatus;

  @override
  List<Object?> get props => [joinStatus];
}

class JoinSuccess extends JoinGameEvent {
  const JoinSuccess({
    required this.roomCode,
    required this.playerId,
    required this.playerName,
  });

  final String roomCode;
  final String playerId;
  final String playerName;

  @override
  List<Object?> get props => [
        roomCode,
        playerId,
        playerName,
      ];
}
