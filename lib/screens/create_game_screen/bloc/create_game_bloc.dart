import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/utils/http.dart';

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
    // on<ResetStatus>(_resetStatus);
  }

  final AppBloc appBloc;

  Future _createGame(CreateGame event, Emitter<CreateGameState> emit) async {
    emit(CreatingState());
    final createRoomResponse = await Http.post(
      uri: '${baseUrl}create-room',
      body: {
        'host_name': event.playerName == '' ? 'Host' : event.playerName,
      },
    ).timeout(Duration(seconds: 1), onTimeout: () {
      print('Timed out');
      return Response('', 408);
    });

    if (createRoomResponse.statusCode == 408) {
      emit(MainState(
        joinStatus: JoinStatus.timedOut,
      ));
      return;
    }
    final crBody = Http.jsonDecode(createRoomResponse.body);
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
    final createGameResponse = await Http.post(
      uri: '${baseUrl}new-game',
      body: body,
    );

    // room_code: str
    // host_id: str
    // categories: list[str]
    // num_rounds: int = 10

    emit(LoadingState());
  }

  // void _resetStatus(ResetStatus event, Emitter<CreateGameState> emit) {
  //   emit(state.copyWith(
  //     joinStatus: JoinStatus.none,
  //   ));
  // }
}
