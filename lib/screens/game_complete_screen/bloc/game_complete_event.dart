part of 'game_complete_bloc.dart';

abstract class GameCompleteEvent extends Equatable {
  const GameCompleteEvent();

  @override
  List<Object?> get props => [];
}

class GetResults extends GameCompleteEvent {
  const GetResults();
}
