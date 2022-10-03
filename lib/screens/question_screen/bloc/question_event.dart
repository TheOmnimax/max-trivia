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

class StartGameResponse extends QuestionEvent {
  // Got message from server to start round
  const StartGameResponse({
    required this.allowed,
    required this.started,
  });

  final bool allowed;
  final bool started;

  @override
  List<Object?> get props => [allowed, started];
}

class RoundComplete extends QuestionEvent {
  const RoundComplete({
    required this.correct,
    this.gameComplete = false,
    required this.winner,
    required this.isWinner,
  });

  final int correct;
  final bool gameComplete;
  final String winner;
  final bool isWinner;

  @override
  List<Object?> get props => [
        correct,
        gameComplete,
        winner,
        isWinner,
      ];
}

class NextRound extends QuestionEvent {
  const NextRound();
}

class GameComplete extends QuestionEvent {
  const GameComplete();
}
