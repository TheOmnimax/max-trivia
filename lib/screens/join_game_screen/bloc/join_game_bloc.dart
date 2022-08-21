import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/utils/http.dart';

part 'join_game_event.dart';
part 'join_game_state.dart';

class JoinGameBloc extends Bloc<JoinGameEvent, JoinGameState> {
  JoinGameBloc()
      : super(const MainState(
          joinStatus: JoinStatus.none,
        )) {
    on<JoinGame>(_joinGame);
  }

  Future _joinGame(JoinGame event, Emitter<JoinGameState> emit) async {
    emit(const JoiningState());
    final response = await Http.post(
      uri: '${baseUrl}add-player',
      body: {
        'room_code': event.roomCode,
        'player_name': event.name,
      },
    );
    final statusCode = response.statusCode;

    if (statusCode >= 500) {
      print(response.statusCode);
    } else if (statusCode == 404) {
      print('Room not found');
      emit(const MainState(joinStatus: JoinStatus.roomNotExists));
    } else if (statusCode >= 400) {
      print(response.statusCode);
    } else if (statusCode >= 200) {
      final responseBody = Http.jsonDecode(response.body);
      final playerId = responseBody['player_id'];
      emit(LoadingState(
        roomCode: event.roomCode,
        playerId: playerId,
        playerName: event.name,
        joinStatus: JoinStatus.joined,
      ));
    }
  }
}
