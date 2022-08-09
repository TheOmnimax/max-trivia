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
