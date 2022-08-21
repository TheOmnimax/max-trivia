import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/utils/http.dart';

import '../../../constants/enums.dart';

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
    on<GameComplete>(_gameComplete);
  }

  final AppBloc appBloc;
  Timer? timer;

  Future _checkServer() async {
    final int checkinTime;
    if (state.roundStatus == RoundStatus.playing) {
      checkinTime = DateTime.now().millisecondsSinceEpoch - state.startTime;
    } else {
      checkinTime = 0;
    }
    final response = await Http.post(
      uri: '${baseUrl}player-checkin',
      body: {
        'room_code': appBloc.state.roomCode,
        'player_id': appBloc.state.playerId,
        'time': checkinTime,
        'ready': state.roundStatus == RoundStatus.ready,
      },
    );
    final data = Http.jsonDecode(response.body);
    if (data.containsKey('started') && (data['started'] as bool == false)) {
      // If game not yet started
    } else if (data['game_complete'] as bool) {
      timer?.cancel();

      await Future.delayed(Duration(seconds: 1));
      add(const GameComplete());
    } else if (data['round_complete'] as bool) {
      final roundStatus = state.roundStatus;
      final correct = data['correct'] as int;
      if (roundStatus == RoundStatus.playing) {
        add(
          TimeUp(
            status: AnswerStatus.noAnswer,
            correct: correct,
          ),
        );
      } else if (roundStatus == RoundStatus.answered) {
        add(
          TimeUp(
            status: AnswerStatus.winner,
            correct: correct,
          ),
        ); // TODO: Update with checks from the server to see if they were really the winner
      }
    } else if (state.roundStatus == RoundStatus.ready) {
      final question = data['question'] as String;
      final choices = List<String>.from(data['choices']);
      add(LoadQuestion(
        question: question,
        choices: choices,
      ));
    } else {}
  }

  void _serverQuery() {
    const duration = Duration(seconds: 2);

    timer = Timer.periodic(duration, (Timer t) async => await _checkServer());
  }

  Future _loadGame(LoadGame event, Emitter<QuestionState> emit) async {
    _serverQuery();
    if (appBloc.state.isHost) {
      emit(PregameState(
        roundStatus: RoundStatus.answered,
      ));
    } else {
      emit(PregameState(
        roundStatus: RoundStatus.ready,
      ));
    }
  }

  Future _startGame(StartGame event, Emitter<QuestionState> emit) async {
    emit(const PregameState(
      roundStatus: RoundStatus.ready,
    ));
    final response = await Http.post(uri: '${baseUrl}start-game', body: {
      'room_code': appBloc.state.roomCode,
      'host_id': appBloc.state.playerId,
    });
    final data = Http.jsonDecode(response.body);
    // final successful = data['successful'] as bool;
  }

  Future _loadQuestion(LoadQuestion event, Emitter<QuestionState> emit) async {
    // final int time;
    // if (state.startTime == 0) {
    //   time = DateTime.now().millisecondsSinceEpoch - state.startTime;
    // } else {
    //   time = state.startTime;
    // }

    emit(PlayingState(
      question: event.question,
      choices: event.choices,
      startTime: DateTime.now().millisecondsSinceEpoch,
      answerStatus: AnswerStatus.waiting,
      roundStatus: RoundStatus.playing,
      selected: -1,
      correct: -1,
    ));
  }

  Future _selectChoice(SelectChoice event, Emitter<QuestionState> emit) async {
    emit(state.copyWith(
      roundStatus: RoundStatus.answered,
      selected: event.selected,
    ));
    final time = DateTime.now().millisecondsSinceEpoch - state.startTime;
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
    final AnswerStatus status;
    if (correct) {
      status = AnswerStatus.correct;
    } else {
      status = AnswerStatus.incorrect;
    }

    emit(state.copyWith(
      answerStatus: status,
    ));
  }

  void _timeUp(TimeUp event, Emitter<QuestionState> emit) {
    emit(
      state.copyWith(
        answerStatus: event.status,
        roundStatus: RoundStatus.ready,
        correct: event.correct,
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
  }

  void _gameComplete(GameComplete event, Emitter<QuestionState> emit) {
    emit(const GameCompleteState());
  }
}
