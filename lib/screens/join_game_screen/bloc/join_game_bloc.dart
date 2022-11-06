import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/utils/http.dart';

part 'join_game_event.dart';
part 'join_game_state.dart';

class JoinGameBloc extends Bloc<JoinGameEvent, JoinGameState> {
  JoinGameBloc({
    required this.appBloc,
  }) : super(const MainState(
          joinStatus: JoinStatus.none,
        )) {
    on<JoinGame>(_joinGame);
    on<JoinError>(_joinError);
    on<JoinSuccess>(_joinSuccess);
  }

  final AppBloc appBloc;

  Future _joinGame(JoinGame event, Emitter<JoinGameState> emit) async {
    print('Joining...');
    emit(const JoiningState());
    final roomCode = event.roomCode.toLowerCase();
    var noResponse = true;
    appBloc.socket.on('add-player', (data) {
      noResponse = false;
      final successful = data['successful'] as bool;
      if (successful) {
        final playerId = data['player_id'] as String;
        add(
          JoinSuccess(
            roomCode: roomCode,
            playerId: playerId,
            playerName: event.name,
          ),
        );
      } else {
        final joinMessage = data['message'] as String;
        if (joinMessage == 'Game does not exist') {
          add(const JoinError(
            joinStatus: JoinStatus.roomNotExists,
          ));
        } else {
          add(const JoinError(joinStatus: JoinStatus.unknown));
        }
      }
    });
    appBloc.socket.emit('add-player', {
      'room_code': roomCode,
      'player_name': event.name,
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (noResponse) {
        print('Timed out');
        add(const JoinError(joinStatus: JoinStatus.timedOut));
      }
    });
  }

  void _joinError(JoinError event, Emitter<JoinGameState> emit) {
    emit(MainState(
      joinStatus: event.joinStatus,
    ));
  }

  void _joinSuccess(JoinSuccess event, Emitter<JoinGameState> emit) {
    appBloc.add(
      AddGameInfo(
        roomCode: event.roomCode,
        playerId: event.playerId,
        isHost: false,
        playerName: event.playerName,
      ),
    );
    emit(LoadingState(
      roomCode: event.roomCode,
      playerId: event.playerId,
      playerName: event.playerName,
      joinStatus: JoinStatus.joined,
    ));
  }
}
