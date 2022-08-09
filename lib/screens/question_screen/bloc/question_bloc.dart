import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/utils/http.dart';

part 'question_event.dart';
part 'question_state.dart';

// TODO: QUESTION: Should there be a new screen for each question, or should the question change in each state?

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc({
    required this.appBloc,
  }) : super(const LoadingState()) {
    on<LoadGame>(_loadGame);
    on<StartGame>(_startGame);
    on<LoadQuestion>(_loadQuestion);
    on<SelectChoice>(_selectChoice);
    on<TimeUp>(_timeUp);
    on<NextRound>(_nextRound);
  }

  final AppBloc appBloc;

  Future _checkServer() async {
    print('Checking server');
    final response = await Http.post(uri: '${baseUrl}player-checkin', body: {
      'room_code': appBloc.state.roomCode,
      'player_id': appBloc.state.playerId,
      'time':
          0, // This isn't needed for this action, but it is to fit with the schema
    });
    final data = Http.jsonDecode(response.body);
    print(data);
    if (data.containsKey('started') && (data['started'] as bool == false)) {
      // If not yet started
    } else {
      final roundComplete = data['round_complete'] as bool;
      final question = data['question'] as String;
      final choices = List<String>.from(data['choices']);

      print('ROUND COMPLETE: $roundComplete');
      if (roundComplete) {
        final winners = data['winners'].map((e) => e as String).toList();
        final isWinner = data['is_winner'] as bool;

        emit(CompleteState(
          question: question,
          choices: choices,
          selected: state.selected,
          startTime: 0,
          status: state.status,
        ));
      } else {
        add(
          LoadQuestion(
            question: question,
            choices: choices,
          ),
        );
      }
      // TODO: Add other data from

      // class PlayerCheckinResponse(BaseModel):
      // question: str
      // choices: list[str]
      // round_complete: bool
      // round_data: Optional[RoundData]
      emit(state);
    }
  }

  void _serverQuery() {
    print('Starting queries...');
    const duration = Duration(seconds: 1);
    Timer.periodic(duration, (Timer t) async => await _checkServer());
  }

  Future _loadGame(LoadGame event, Emitter<QuestionState> emit) async {
    print('Loading game...');
    _serverQuery();
    emit(const PregameState());
  }

  Future _startGame(StartGame event, Emitter<QuestionState> emit) async {
    final response = await Http.post(uri: '${baseUrl}start-game', body: {
      'room_code': appBloc.state.roomCode,
      'host_id': appBloc.state.playerId,
    });
    final data = Http.jsonDecode(response.body);
    // final successful = data['successful'] as bool;
  }

  Future _loadQuestion(LoadQuestion event, Emitter<QuestionState> emit) async {
    if ((state is PregameState) || (state is CompleteState)) {
      final int time;
      if (state.startTime == 0) {
        time = DateTime.now().millisecondsSinceEpoch - state.startTime;
      } else {
        time = state.startTime;
      }

      emit(PlayingState(
        question: event.question,
        choices: event.choices,
        startTime: time,
      ));
    }
  }

  Future _selectChoice(SelectChoice event, Emitter<QuestionState> emit) async {
    final time = DateTime.now().millisecondsSinceEpoch - state.startTime;
    print('Time: $time');
    final response = await Http.post(
      uri: '${baseUrl}answer-question',
      body: {
        'answer': event.selected,
        'time': time,
        'player_id': appBloc.state.playerId,
        'room_code': appBloc.state.roomCode,
      },
    );

    final body = Http.jsonDecode(response.body);
    final correct = body['player_correct'] as bool;
    final CompleteStatus status;
    if (correct) {
      status = CompleteStatus.correct;
    } else {
      status = CompleteStatus.incorrect;
    }

    emit(
      CompleteState(
        question: state.question,
        choices: state.choices,
        selected: state.selected,
        startTime: 0,
        status: status,
      ),
    );
  }

  void _timeUp(TimeUp event, Emitter<QuestionState> emit) {
    final CompleteStatus status;
    if (event.isWinner) {
      status = CompleteStatus.winner;
    } else {
      status = state.status;
    }
    emit(
      CompleteState(
        question: state.question,
        choices: state.choices,
        selected: state.selected,
        startTime: 0,
        status: status,
      ),
    );
  }

  Future _nextRound(NextRound event, Emitter<QuestionState> emit) async {
    final response = await Http.post(
      uri: '${baseUrl}next-round',
      body: {
        'room_code': appBloc.state.roomCode,
        'host_id': appBloc.state.playerId,
      },
    );
    print(response.statusCode);
  }
}
