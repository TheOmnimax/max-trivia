import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/screens/game_complete_screen/bloc/game_complete_bloc.dart';
import 'package:max_trivia/shared_widgets/shared_widgets.dart';

class GameCompleteScreen extends StatelessWidget {
  const GameCompleteScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCompleteBloc(
        appBloc: context.read<AppBloc>(),
      )..add(const GetResults()),
      child: const GameCompleteMain(),
    );
  }
}

class GameCompleteMain extends StatelessWidget {
  const GameCompleteMain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        child: BlocBuilder<GameCompleteBloc, GameCompleteState>(
      builder: (BuildContext context, state) {
        if (state is LoadingState) {
          return const Text('Loading, please wait...');
        } else if (state is ResultsState) {
          final winners = state.winners;

          if (winners.isEmpty) {
            return const GenericText('There were no winners! You guys stink.');
          } else {
            List<Widget> winnerRows = <Widget>[];
            final scores = state.scores;
            for (final playerName in scores.keys) {
              winnerRows.add(Text('$playerName: ${scores[playerName]}'));
            }

            return Column(
              children: [
                Text(
                    'Winner${winners.length > 1 ? 's' : ''}: ${winners.join(', ')}'),
                Column(
                  children: winnerRows,
                )
              ],
            );
          }
        } else {
          return Text('Invalid state on results screen: $state');
        }
      },
    ));
  }
}
