import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/utils/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'question_event.dart';
part 'question_state.dart';

// TODO: QUESTION: Should there be a new screen for each question, or should the question change in each state?

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc({
    required this.appBloc,
  }) : super(const LoadingState()) {
    on<LoadGame>(_loadGame);
    on<StartGame>(_startGame);
    on<StartGameResponse>(_startGameResponse);
    on<LoadQuestion>(_loadQuestion);
    on<SelectChoice>(_selectChoice);
    on<RoundComplete>(_roundComplete);
    on<NextRound>(_nextRound);
    on<GameComplete>(_gameComplete);

    final socket = appBloc.socket;

    socket.on('round-complete', (data) {
      print('Event: Round complete');
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
      print('Event: Next round');
      final question = data['question'] as String;
      final choices = List<String>.from(data['choices']);
      add(LoadQuestion(
        question: question,
        choices: choices,
      ));
    });

    appBloc.socket.on('game-status', (data) {
      print('Event: Game status');
      final players = List<String>.from(data['player_names']);
      if (state is LoadingState) {
        print('Pregame state');
        emit(
          PregameState(
            players: players,
            roundStatus: RoundStatus.answered,
          ),
        );
      } else {
        emit(
          state.copyWith(
            players: players,
          ),
        );
      }
    }); // END game-status event

    appBloc.socket.on('game-complete', (data) {
      print('Event: Game complete');
      final scoresRaw = data['scores'] as Map<String, dynamic>;
      final scores = <String, int>{};
      print(scoresRaw);
      print('Getting names');
      for (final name in scoresRaw.keys) {
        print(name);
        scores[name] = scoresRaw[name] as int;
      }
      print('Getting winnners: ${data['winners']}');
      final winners = List<String>.from(data['winners']);
      print('Adding event');
      add(
        GameComplete(
          scores: scores,
          winners: winners,
        ),
      );
      print('Added');
    });
  }

  final AppBloc appBloc;
  Timer? timer;

  // final _channel = WebSocketChannel.connect(
  //     // Uri.parse('${wsUrl}socket-test'),
  //     );

  Future _loadGame(LoadGame event, Emitter<QuestionState> emit) async {
    appBloc.socket.emit('pregame-status', {
      'player_id': appBloc.state.playerId,
      'room_code': appBloc.state.roomCode,
    });
  }

  Future _startGame(StartGame event, Emitter<QuestionState> emit) async {
    emit(const PregameState(
      players: [],
      // score: {},
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
      print('Event: Start game');
      print(body);
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
    // final int time;
    // if (state.startTime == 0) {
    //   time = DateTime.now().millisecondsSinceEpoch - state.startTime;
    // } else {
    //   time = state.startTime;
    // }

    emit(PlayingState(
      players: state.players,
      score: state.scores,
      question: event.question,
      choices: event.choices,
      startTime: DateTime.now().millisecondsSinceEpoch,
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
      'room_code': appBloc.state.roomCode,
      'player_id': appBloc.state.playerId,
      'answer': event.selected,
    });
    final time = DateTime.now().millisecondsSinceEpoch - state.startTime;
    // final response = await Http.post(
    //   uri: '${baseUrl}answer-question',
    //   body: {
    //     'answer': event.selected,
    //     'time': time,
    //     'player_id': appBloc.state.playerId,
    //     'room_code': appBloc.state.roomCode,
    //   },
    // );

    // final body = Http.jsonDecode(response.body);
    // final correct = body['player_correct'] as bool;
    // final AnswerStatus status;
    // if (correct) {
    //   status = AnswerStatus.correct;
    // } else {
    //   status = AnswerStatus.incorrect;
    // }
    //
    // emit(state.copyWith(
    //   answerStatus: status,
    // ));
  }

  void _roundComplete(RoundComplete event, Emitter<QuestionState> emit) {
    final AnswerStatus status;
    if (event.isWinner) {
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
    print('Emitting game complete');
    emit(GameCompleteState(
      scores: event.scores,
      winners: event.winners,
    ));
  }
}
