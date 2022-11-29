import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';

part 'game_complete_event.dart';
part 'game_complete_state.dart';

class GameCompleteBloc extends Bloc<GameCompleteEvent, GameCompleteState> {
  GameCompleteBloc({
    required this.appBloc,
  }) : super(const LoadingState()) {
    on<GetResults>(_getResults);
    on<ShowResults>(_showResults);
  }

  final AppBloc appBloc;

  Future _getResults(GetResults event, Emitter<GameCompleteState> emit) async {
    appBloc.socket.on('get-results', (data) {
      final scoresRaw = data['scores'] as Map<String, dynamic>;
      final scores = <String, int>{};
      for (final name in scoresRaw.keys) {
        scores[name] = scoresRaw[name] as int;
      }
      final winners = List<String>.from(data['winners']);
      add(
        ShowResults(
          scores: scores,
          winners: winners,
        ),
      );
    });
    appBloc.socket.emit('get-results', {
      'room_code': appBloc.state.roomCode,
    });
  }

  void _showResults(ShowResults event, Emitter<GameCompleteState> emit) {
    emit(
      ResultsState(
        scores: event.scores,
        winners: event.winners,
      ),
    );
  }
}
