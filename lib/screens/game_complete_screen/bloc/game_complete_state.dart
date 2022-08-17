part of 'game_complete_bloc.dart';

abstract class GameCompleteState extends Equatable {
  const GameCompleteState();

  @override
  List<Object?> get props => [];
}

class LoadingState extends GameCompleteState {
  const LoadingState();
}

class ResultsState extends GameCompleteState {
  const ResultsState({
    required this.scores,
    required this.winners,
  });

  final Map<String, int> scores;
  final List<String> winners;

  @override
  List<Object?> get props => [scores, winners];
}
