import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/screens/question_screen/bloc/question_bloc.dart';

part 'choice_widget.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuestionBloc(appBloc: context.read<AppBloc>())
        ..add(
          const LoadGame(),
        ),
      child: const QuestionScreenMain(),
    );
  }
}

class QuestionScreenMain extends StatelessWidget {
  const QuestionScreenMain({Key? key}) : super(key: key);

  List<ChoiceWidget> _getChoiceWidgets({
    required List<String> choices,
    required Function(int) onSelected,
  }) {
    final choiceWidgets = <ChoiceWidget>[];

    for (int c = 0; c < choices.length; c++) {
      final choice = choices[c];
      choiceWidgets.add(ChoiceWidget(
        choice: choice,
        onPressed: () {
          onSelected(c);
        },
      ));
    }

    return choiceWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<QuestionBloc, QuestionState>(
          listener: (context, state) {
            if (state is GameCompleteState) {
              Navigator.popAndPushNamed(context, '/game-complete');
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const Text('Loading...');
            } else if (state is PregameState) {
              if (context.read<AppBloc>().state.isHost) {
                return Column(
                  children: [
                    Text(
                        'Room code: ${context.read<AppBloc>().state.roomCode}'),
                    TextButton(
                        onPressed: () {
                          context.read<QuestionBloc>().add(
                                const StartGame(),
                              );
                        },
                        child: const Text('Start')),
                  ],
                );
              } else {
                return const Text('Please wait for host to start game...');
              }
            } else if (state is PlayingState) {
              return Column(
                children: [
                  Container(
                    child: Text(state.question),
                  ),
                  Column(
                    children: _getChoiceWidgets(
                        choices: state.choices,
                        onSelected: (int value) {
                          context
                              .read<QuestionBloc>()
                              .add(SelectChoice(selected: value));
                        }),
                  )
                ],
              );
            } else if (state is RoundCompleteState) {
              if (context.read<AppBloc>().state.isHost) {
                return TextButton(
                    onPressed: () {
                      context.read<QuestionBloc>().add(NextRound());
                    },
                    child: Text('Next round'));
              } else {
                return Text('Please wait for next round...');
              }
            } else if (state is GameCompleteState) {
              return Text('Getting results...');
            } else {
              return Text('Invalid state');
            }
          },
        ),
      ),
    );
  }
}
