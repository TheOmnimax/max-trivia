part of 'game_complete_bloc.dart';

abstract class GameCompleteEvent extends Equatable {
  const GameCompleteEvent();

  @override
  List<Object?> get props => [];
}

class GetResults extends GameCompleteEvent {
  const GetResults();
}

class ShowResults extends GameCompleteEvent {
  const ShowResults({
    required this.scores,
    required this.winners,
  });

  final Map<String, int> scores;
  final List<String> winners;

  @override
  List<Object?> get props => [scores, winners];
}
