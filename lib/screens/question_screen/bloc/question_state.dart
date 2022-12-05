part of 'question_bloc.dart';

abstract class QuestionState extends Equatable {
  const QuestionState({
    required this.players,
    required this.scores,
    required this.roundStatus,
    required this.question,
    required this.choices,
    required this.selected,
    required this.correct,
    required this.answerStatus,
    required this.roundNum,
    this.winner = '',
  });

  final List<String> players;
  final Map<String, int>
      scores; // This is currently not used, but it can be used for an update later where scores are displayed as the game is ongoing
  final int roundNum;
  final String question;
  final List<String> choices;
  final int selected;
  final int correct;
  final AnswerStatus answerStatus;
  final RoundStatus roundStatus;
  final String winner;

  @override
  List<Object?> get props => [
        players,
        scores,
        roundNum,
        question,
        choices,
        selected,
        correct,
        answerStatus,
        roundStatus,
        winner,
      ];

  QuestionState copyWith({
    List<String>? players,
    Map<String, int>? scores,
    int? roundNum,
    String? question,
    List<String>? choices,
    int? selected,
    int? correct,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
    String? winner,
  });
}

class LoadingState extends QuestionState {
  const LoadingState()
      : super(
          players: const <String>[],
          scores: const <String, int>{},
          roundNum: 0,
          question: '',
          choices: const [],
          selected: -1,
          correct: -1,
          answerStatus: AnswerStatus.noAnswer,
          roundStatus: RoundStatus.ready,
        );

  @override
  LoadingState copyWith({
    List<String>? players,
    Map<String, int>? scores,
    int? roundNum,
    String? question,
    List<String>? choices,
    int? selected,
    int? correct,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
    String? winner,
  }) {
    return const LoadingState();
  }
}

class PregameState extends QuestionState {
  const PregameState({
    required List<String> players,
    required RoundStatus roundStatus,
  }) : super(
          players: players,
          scores: const <String, int>{},
          roundNum: 0,
          question: '',
          choices: const [],
          selected: -1,
          correct: -1,
          answerStatus: AnswerStatus.noAnswer,
          roundStatus: roundStatus,
        );

  @override
  PregameState copyWith({
    List<String>? players,
    Map<String, int>? scores,
    int? roundNum,
    String? question,
    List<String>? choices,
    int? selected,
    int? correct,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
    String? winner,
  }) {
    return PregameState(
      players: players ?? this.players,
      roundStatus: roundStatus ?? this.roundStatus,
    );
  }
}

class PlayingState extends QuestionState {
  const PlayingState({
    required List<String> players,
    required Map<String, int> score,
    required int roundNum,
    required String question,
    required List<String> choices,
    required int selected,
    required int correct,
    required AnswerStatus answerStatus,
    required RoundStatus roundStatus,
    String winner = '',
  }) : super(
          players: const <String>[],
          scores: const <String, int>{},
          roundNum: roundNum,
          question: question,
          choices: choices,
          selected: selected,
          correct: correct,
          answerStatus: answerStatus,
          roundStatus: roundStatus,
          winner: winner,
        );

  @override
  PlayingState copyWith({
    List<String>? players,
    Map<String, int>? scores,
    int? roundNum,
    String? question,
    List<String>? choices,
    int? selected,
    int? correct,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
    String? winner,
  }) {
    return PlayingState(
      players: players ?? this.players,
      score: scores ?? this.scores,
      roundNum: roundNum ?? this.roundNum,
      question: question ?? this.question,
      choices: choices ?? this.choices,
      selected: selected ?? this.selected,
      correct: correct ?? this.correct,
      answerStatus: answerStatus ?? this.answerStatus,
      roundStatus: roundStatus ?? this.roundStatus,
      winner: winner ?? this.winner,
    );
  }
}

class GameCompleteState extends QuestionState {
  // Currently, the state properties are not used, but keeping them for now in case they are needed in a future update
  const GameCompleteState({
    required Map<String, int> scores,
    required this.winners,
  }) : super(
          players: const <String>[],
          scores: scores,
          roundNum: -1,
          question: '',
          choices: const [],
          selected: -1,
          correct: -1,
          answerStatus: AnswerStatus.answered,
          roundStatus: RoundStatus.ready,
        );

  final List<String> winners;

  @override
  GameCompleteState copyWith({
    List<String>? players,
    Map<String, int>? scores,
    int? roundNum,
    String? question,
    List<String>? choices,
    int? selected,
    int? correct,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
    String? winner,
    List<String>? winners,
  }) {
    return GameCompleteState(
      scores: scores ?? this.scores,
      winners: winners ?? this.winners,
    );
  }
}
