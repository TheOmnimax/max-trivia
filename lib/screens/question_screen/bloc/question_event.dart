part of 'question_bloc.dart';

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object?> get props => [];
}

class LoadGame extends QuestionEvent {
  const LoadGame();
}

class StartGame extends QuestionEvent {
  const StartGame();
}

class LoadQuestion extends QuestionEvent {
  const LoadQuestion({
    required this.question,
    required this.choices,
  });

  final String question;
  final List<String> choices;

  @override
  List<Object?> get props => [question, choices];
}

class SelectChoice extends QuestionEvent {
  const SelectChoice({
    required this.selected,
  });

  final int selected;

  @override
  List<Object?> get props => [selected];
}

class TimeUp extends QuestionEvent {
  const TimeUp({
    required this.isWinner,
  });

  final bool isWinner;
}

class NextRound extends QuestionEvent {
  const NextRound();
}
