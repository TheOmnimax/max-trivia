import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/utils/http.dart';

part 'game_complete_event.dart';
part 'game_complete_state.dart';

class GameCompleteBloc extends Bloc<GameCompleteEvent, GameCompleteState> {
  GameCompleteBloc({
    required this.appBloc,
  }) : super(LoadingState()) {
    on<GetResults>(_getResults);
  }

  final AppBloc appBloc;

  Future _getResults(GetResults event, Emitter<GameCompleteState> emit) async {
    final response = await Http.post(
      uri: '${baseUrl}get-results',
      body: {
        'room_code': appBloc.state.roomCode,
      },
    );
    final data = Http.jsonDecode(response.body);
    // final scoresRaw = Http.jsonDecode(data['scores'] as String);
    final scores = <String, int>{};
    final scoresRaw = data['scores'] as Map<String, dynamic>;
    for (final name in scoresRaw.keys) {
      scores[name] = scoresRaw[name] as int;
    }
    final winners = <String>[];
    for (final winner in data['winners']) {
      winners.add(winner as String);
    } // TODO: Is there a better shorthand for this?
    emit(ResultsState(
      scores: scores,
      winners: winners,
    ));
  }
}
