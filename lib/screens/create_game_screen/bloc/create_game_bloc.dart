import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            playerName: '',
          ),
        ) {
    on<UpdateName>(_updateName);
    on<CreateGame>(_createGame);
  }

  final AppBloc appBloc;

  void _updateName(UpdateName event, Emitter<CreateGameState> emit) {
    emit(MainState(playerName: event.playerName));
  }

  Future _createGame(CreateGame event, Emitter<CreateGameState> emit) async {
    emit(CreatingState(
      playerName: state.playerName,
    ));
    final createRoomResponse = await Http.post(
      uri: '${baseUrl}create-room',
      body: {
        'host_name': state.playerName == '' ? 'Host' : state.playerName,
      },
    );
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
      'host_name': state.playerName,
    };
    final createGameResponse = await Http.post(
      uri: '${baseUrl}new-game',
      body: body,
    );

    // room_code: str
    // host_id: str
    // categories: list[str]
    // num_rounds: int = 10

    emit(LoadingState(
      playerName: state.playerName,
    ));
  }
}
