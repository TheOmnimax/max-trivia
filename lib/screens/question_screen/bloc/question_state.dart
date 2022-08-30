part of 'question_bloc.dart';

abstract class QuestionState extends Equatable {
  const QuestionState({
    required this.players,
    required this.scores,
    required this.question,
    required this.choices,
    required this.selected,
    required this.correct,
    required this.startTime,
    required this.answerStatus,
    required this.roundStatus,
    this.winners = const <String>[],
    this.isWinner = false,
  });

  final List<String> players;
  final Map<String, int> scores;
  final String question;
  final List<String> choices;
  final int selected;
  final int correct;
  final int startTime;
  final AnswerStatus answerStatus;
  final RoundStatus roundStatus;
  final List<String> winners;
  final bool isWinner;

  @override
  List<Object?> get props => [
        players,
        scores,
        question,
        choices,
        selected,
        correct,
        startTime,
        answerStatus,
        roundStatus,
        winners,
        isWinner,
      ];

  QuestionState copyWith({
    List<String>? players,
    Map<String, int>? scores,
    String? question,
    List<String>? choices,
    int? selected,
    int? correct,
    int? startTime,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
    List<String>? winners,
    bool? isWinner,
  });
}

class LoadingState extends QuestionState {
  const LoadingState()
      : super(
          players: const <String>[],
          scores: const <String, int>{},
          question: '',
          choices: const [],
          selected: -1,
          correct: -1,
          startTime: 0,
          answerStatus: AnswerStatus.noAnswer,
          roundStatus: RoundStatus.ready,
        );

  @override
  LoadingState copyWith({
    List<String>? players,
    Map<String, int>? scores,
    String? question,
    List<String>? choices,
    int? selected,
    int? correct,
    int? startTime,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
    List<String>? winners,
    bool? isWinner,
  }) {
    return const LoadingState();
  }
}

class PregameState extends QuestionState {
  const PregameState({
    required List<String> players,
    required Map<String, int> score,
    required RoundStatus roundStatus,
  }) : super(
          players: const <String>[],
          scores: const <String, int>{},
          question: '',
          choices: const [],
          selected: -1,
          correct: -1,
          startTime: 0,
          answerStatus: AnswerStatus.noAnswer,
          roundStatus: roundStatus,
        );

  @override
  PregameState copyWith({
    List<String>? players,
    Map<String, int>? scores,
    String? question,
    List<String>? choices,
    int? selected,
    int? correct,
    int? startTime,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
    List<String>? winners,
    bool? isWinner,
  }) {
    return PregameState(
      players: players ?? this.players,
      score: scores ?? this.scores,
      roundStatus: roundStatus ?? this.roundStatus,
    );
  }
}

class PlayingState extends QuestionState {
  const PlayingState({
    required List<String> players,
    required Map<String, int> score,
    required String question,
    required List<String> choices,
    required int selected,
    required int correct,
    required int startTime,
    required AnswerStatus answerStatus,
    required RoundStatus roundStatus,
    required List<String> winners,
    required bool isWinner,
  }) : super(
          players: const <String>[],
          scores: const <String, int>{},
          question: question,
          choices: choices,
          selected: selected,
          correct: correct,
          startTime: startTime,
          answerStatus: answerStatus,
          roundStatus: roundStatus,
          winners: winners,
          isWinner: isWinner,
        );

  @override
  PlayingState copyWith({
    List<String>? players,
    Map<String, int>? scores,
    String? question,
    List<String>? choices,
    int? selected,
    int? correct,
    int? startTime,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
    List<String>? winners,
    bool? isWinner,
  }) {
    return PlayingState(
      players: players ?? this.players,
      score: scores ?? this.scores,
      question: question ?? this.question,
      choices: choices ?? this.choices,
      selected: selected ?? this.selected,
      correct: correct ?? this.correct,
      startTime: startTime ?? this.startTime,
      answerStatus: answerStatus ?? this.answerStatus,
      roundStatus: roundStatus ?? this.roundStatus,
      winners: winners ?? this.winners,
      isWinner: isWinner ?? this.isWinner,
    );
  }
}

class GameCompleteState extends QuestionState {
  const GameCompleteState()
      : super(
          players: const <String>[],
          scores: const <String, int>{},
          question: '',
          choices: const [],
          selected: -1,
          correct: -1,
          startTime: 0,
          answerStatus: AnswerStatus.answered,
          roundStatus: RoundStatus.ready,
        );

  @override
  GameCompleteState copyWith({
    List<String>? players,
    Map<String, int>? scores,
    String? question,
    List<String>? choices,
    int? selected,
    int? correct,
    int? startTime,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
    List<String>? winners,
    bool? isWinner,
  }) {
    return const GameCompleteState();
  }
}
