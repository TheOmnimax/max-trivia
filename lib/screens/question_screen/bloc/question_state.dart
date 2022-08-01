part of 'question_bloc.dart';

abstract class QuestionState extends Equatable {
  const QuestionState({
    required this.question,
    required this.choices,
    required this.selected,
    required this.startTime,
    required this.status,
  });

  final String question;
  final List<String> choices;
  final int selected;
  final int startTime;
  final CompleteStatus status;

  @override
  List<Object?> get props => [
        question,
        choices,
        selected,
        startTime,
        status,
      ];

  QuestionState copyWith();
}

class LoadingState extends QuestionState {
  const LoadingState()
      : super(
          question: '',
          choices: const [],
          selected: -1,
          startTime: 0,
          status: CompleteStatus.noAnswer,
        );

  @override
  LoadingState copyWith() {
    return const LoadingState();
  }
}

class PregameState extends QuestionState {
  const PregameState()
      : super(
          question: '',
          choices: const [],
          selected: -1,
          startTime: 0,
          status: CompleteStatus.noAnswer,
        );

  @override
  PregameState copyWith() {
    return const PregameState();
  }
}

class PlayingState extends QuestionState {
  const PlayingState({
    required String question,
    required List<String> choices,
    required int startTime,
  }) : super(
          question: question,
          choices: choices,
          selected: -1,
          startTime: startTime,
          status: CompleteStatus.noAnswer,
        );

  @override
  PlayingState copyWith({
    String? question,
    List<String>? choices,
    int? startTime,
  }) {
    return PlayingState(
      question: question ?? this.question,
      choices: choices ?? this.choices,
      startTime: startTime ?? this.startTime,
    );
  }
}

class CompleteState extends QuestionState {
  const CompleteState({
    required String question,
    required List<String> choices,
    required int selected,
    required CompleteStatus status,
    required int startTime,
  }) : super(
          question: question,
          choices: choices,
          selected: selected,
          startTime: startTime,
          status: status,
        );

  @override
  CompleteState copyWith({
    String? question,
    List<String>? choices,
    int? selected,
    int? startTime,
    CompleteStatus? status,
  }) {
    return CompleteState(
      question: question ?? this.question,
      choices: choices ?? this.choices,
      selected: selected ?? this.selected,
      startTime: startTime ?? this.startTime,
      status: status ?? this.status,
    );
  }
}
