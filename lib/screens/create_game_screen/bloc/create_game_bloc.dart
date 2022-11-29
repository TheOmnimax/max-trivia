import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/constants/constants.dart';

part 'create_game_event.dart';
part 'create_game_state.dart';

class CreateGameBloc extends Bloc<CreateGameEvent, CreateGameState> {
  CreateGameBloc({
    required this.appBloc,
  }) : super(
          const MainState(
            joinStatus: JoinStatus.none,
          ),
        ) {
    on<CreateGame>(_createGame);
    on<StartGame>(_startGame);
  }

  final AppBloc appBloc;

  Future _createGame(CreateGame event, Emitter<CreateGameState> emit) async {
    emit(const CreatingState()); // In the process of creating the game
    final socket = appBloc.socket;

    socket.on('create-room', (crBody) {
      final roomCode = crBody['room_code'];
      final hostId = crBody['host_id'];
      appBloc.add(
        AddGameInfo(
          roomCode: roomCode,
          playerId: hostId,
          isHost: true,
          playerName: event.playerName,
        ),
      );
      final body = {
        'room_code': roomCode,
        'host_id': hostId,
        'categories': event.categories,
        'num_rounds': event.numRounds,
        'host_name': event.playerName,
      };
      socket.emit('new-game', body);
    });

    socket.on('new-game', (data) {
      add(const StartGame());
    });

    socket.emit('create-room', {
      'host_name': event.playerName == '' ? 'Host' : event.playerName,
    });
  }

  void _startGame(StartGame event, Emitter<CreateGameState> emit) {
    emit(const LoadingState());
  }
}
