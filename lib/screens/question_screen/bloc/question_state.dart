part of 'question_bloc.dart';

abstract class QuestionState extends Equatable {
  const QuestionState({
    required this.question,
    required this.choices,
    required this.selected,
    // required this.correct,
    required this.startTime,
    required this.answerStatus,
    required this.roundStatus,
  });

  final String question;
  final List<String> choices;
  final int selected;
  // final int correct;
  final int startTime;
  final AnswerStatus answerStatus;
  final RoundStatus roundStatus;

  @override
  List<Object?> get props => [
        question,
        choices,
        selected,
        startTime,
        answerStatus,
        roundStatus,
      ];

  QuestionState copyWith(
      {String? question,
      List<String>? choices,
      int? selected,
      int? startTime,
      AnswerStatus? answerStatus,
      RoundStatus? roundStatus});
}

class LoadingState extends QuestionState {
  const LoadingState()
      : super(
          question: '',
          choices: const [],
          selected: -1,
          startTime: 0,
          answerStatus: AnswerStatus.noAnswer,
          roundStatus: RoundStatus.ready,
        );

  @override
  LoadingState copyWith({
    String? question,
    List<String>? choices,
    int? selected,
    int? startTime,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
  }) {
    return const LoadingState();
  }
}

class PregameState extends QuestionState {
  const PregameState({
    required RoundStatus roundStatus,
  }) : super(
          question: '',
          choices: const [],
          selected: -1,
          startTime: 0,
          answerStatus: AnswerStatus.noAnswer,
          roundStatus: roundStatus,
        );

  @override
  PregameState copyWith({
    String? question,
    List<String>? choices,
    int? selected,
    int? startTime,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
  }) {
    return PregameState(roundStatus: roundStatus ?? this.roundStatus);
  }
}

class PlayingState extends QuestionState {
  const PlayingState({
    required String question,
    required List<String> choices,
    required int selected,
    required int startTime,
    required AnswerStatus answerStatus,
    required RoundStatus roundStatus,
  }) : super(
          question: question,
          choices: choices,
          selected: selected,
          startTime: startTime,
          answerStatus: answerStatus,
          roundStatus: roundStatus,
        );

  @override
  PlayingState copyWith({
    String? question,
    List<String>? choices,
    int? selected,
    int? startTime,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
  }) {
    return PlayingState(
      question: question ?? this.question,
      choices: choices ?? this.choices,
      selected: selected ?? this.selected,
      startTime: startTime ?? this.startTime,
      answerStatus: answerStatus ?? this.answerStatus,
      roundStatus: roundStatus ?? this.roundStatus,
    );
  }
}

class GameCompleteState extends QuestionState {
  const GameCompleteState()
      : super(
          question: '',
          choices: const [],
          selected: -1,
          startTime: 0,
          answerStatus: AnswerStatus.answered,
          roundStatus: RoundStatus.ready,
        );

  GameCompleteState copyWith({
    String? question,
    List<String>? choices,
    int? selected,
    int? startTime,
    AnswerStatus? answerStatus,
    RoundStatus? roundStatus,
  }) {
    return const GameCompleteState();
  }
}

// TODO: Add state that loads game complete screen
