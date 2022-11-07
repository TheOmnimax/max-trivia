import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/constants/constants.dart';

part 'question_event.dart';
part 'question_state.dart';

// TODO: QUESTION: Should there be a new screen for each question, or should the question change in each state?

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc({
    required this.appBloc,
  }) : super(const LoadingState()) {
    on<LoadGame>(_loadGame);
    on<ShowPregame>(_showPregame);
    on<AddPlayer>(_addPlayer);
    on<StartGame>(_startGame);
    on<StartGameResponse>(_startGameResponse);
    on<LoadQuestion>(_loadQuestion);
    on<SelectChoice>(_selectChoice);
    on<RoundComplete>(_roundComplete);
    on<GameComplete>(_gameComplete);

    final socket = appBloc.socket;

    socket.on('round-complete', (data) {
      final isWinner = data['is_winner'] as bool;
      final winnerName = data['winner_name'] as String;
      final correct = data['correct'] as int;

      add(
        RoundComplete(
          correct: correct,
          winner: winnerName,
          isWinner: isWinner,
        ),
      );
    });

    socket.on('next-round', (data) {
      final roundNum = data['round_num'] as int;
      final question = data['question'] as String;
      final choices = List<String>.from(data['choices']);
      add(LoadQuestion(
        roundNum: roundNum,
        question: question,
        choices: choices,
      ));
    });

    appBloc.socket.on('game-status', (data) {
      final players = List<String>.from(data['player_names']);
      if (state is LoadingState) {
        add(ShowPregame(players: players));
      } else {
        add(AddPlayer(players: players));
      }
    }); // END game-status event

    appBloc.socket.on('game-complete', (data) {
      final scoresRaw = data['scores'] as Map<String, dynamic>;
      final scores = <String, int>{};
      for (final name in scoresRaw.keys) {
        scores[name] = scoresRaw[name] as int;
      }
      final winners = List<String>.from(data['winners']);
      add(
        GameComplete(
          scores: scores,
          winners: winners,
        ),
      );
    });
  }

  final AppBloc appBloc;
  Timer? timer;

  Future _loadGame(LoadGame event, Emitter<QuestionState> emit) async {
    appBloc.socket.emit('pregame-status', {
      'player_id': appBloc.state.playerId,
      'room_code': appBloc.state.roomCode,
    });
  }

  void _showPregame(ShowPregame event, Emitter<QuestionState> emit) {
    emit(PregameState(
        players: event.players, roundStatus: RoundStatus.answered));
  }

  void _addPlayer(AddPlayer event, Emitter<QuestionState> emit) {
    emit(state.copyWith(players: event.players));
  }

  Future _startGame(StartGame event, Emitter<QuestionState> emit) async {
    emit(const PregameState(
      players: [],
      roundStatus: RoundStatus.ready,
    ));
    appBloc.socket.emit(
      'start-game',
      {
        'room_code': appBloc.state.roomCode,
        'host_id': appBloc.state.playerId,
      },
    );

    appBloc.socket.on('start-game', (body) {
      add(StartGameResponse(
        allowed: body['allowed'] as bool,
        started: body['started'] as bool,
      ));
    });
  }

  void _startGameResponse(
      StartGameResponse event, Emitter<QuestionState> emit) {
    // TODO: Implement
  }

  Future _loadQuestion(LoadQuestion event, Emitter<QuestionState> emit) async {
    emit(PlayingState(
      players: state.players,
      score: state.scores,
      roundNum: event.roundNum,
      question: event.question,
      choices: event.choices,
      answerStatus: AnswerStatus.waiting,
      roundStatus: RoundStatus.playing,
      selected: -1,
      correct: -1,
      winner: '',
      isWinner: false,
    ));
  }

  Future _selectChoice(SelectChoice event, Emitter<QuestionState> emit) async {
    emit(state.copyWith(
      roundStatus: RoundStatus.answered,
      selected: event.selected,
    ));

    appBloc.socket.emit('answer-question', {
      'round': state.roundNum,
      'room_code': appBloc.state.roomCode,
      'player_id': appBloc.state.playerId,
      'answer': event.selected,
    });
  }

  void _roundComplete(RoundComplete event, Emitter<QuestionState> emit) {
    final AnswerStatus status;
    if (event.isWinner) {
      status = AnswerStatus.winner;
    } else if (state.selected == event.correct) {
      // Correct answer, but someone else was faster
      status = AnswerStatus.correct;
    } else {
      status = AnswerStatus.incorrect;
    }

    emit(state.copyWith(
      answerStatus: status,
      correct: event.correct,
      winner: event.winner,
    ));
  }

  void _gameComplete(GameComplete event, Emitter<QuestionState> emit) {
    emit(GameCompleteState(
      scores: event.scores,
      winners: event.winners,
    ));
  }
}
