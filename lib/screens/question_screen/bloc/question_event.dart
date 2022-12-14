part of 'question_bloc.dart';

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object?> get props => [];
}

class LoadGame extends QuestionEvent {
  const LoadGame();
}

class ShowPregame extends QuestionEvent {
  const ShowPregame({
    required this.players,
  });

  final List<String> players;

  @override
  List<Object?> get props => [players];
}

class AddPlayer extends QuestionEvent {
  const AddPlayer({
    required this.players,
  });

  final List<String> players;

  @override
  List<Object?> get props => [players];
}

class StartGame extends QuestionEvent {
  const StartGame();
}

class LoadQuestion extends QuestionEvent {
  const LoadQuestion({
    required this.roundNum,
    required this.question,
    required this.choices,
  });

  final int roundNum;
  final String question;
  final List<String> choices;

  @override
  List<Object?> get props => [
        question,
        choices,
        roundNum,
      ];
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

class GameComplete extends QuestionEvent {
  const GameComplete({
    required this.scores,
    required this.winners,
  });

  final Map<String, int> scores;
  final List<String> winners;

  @override
  List<Object?> get props => [scores, winners];
}
