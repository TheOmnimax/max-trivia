import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/screens/game_complete_screen/game_complete_screen.dart';
import 'package:max_trivia/screens/question_screen/bloc/question_bloc.dart';
import 'package:max_trivia/utils/navigation.dart';

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
    int selected = -1,
    int correct = -1,
  }) {
    final choiceWidgets = <ChoiceWidget>[];

    for (int c = 0; c < choices.length; c++) {
      final choice = choices[c];
      choiceWidgets.add(
        ChoiceWidget(
          choice: choice,
          onPressed: () {
            onSelected(c);
          },
          choiceValue: c,
          selected: selected,
          correct: correct,
        ),
      );
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
              print('Game complete new screen...');
              newScreen(
                context: context,
                screen: GameCompleteScreen(),
              );
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const Text('Loading...');
            } else if (state is PregameState) {
              if (state.roundStatus == RoundStatus.answered) {
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
              }
              if (state.roundStatus == RoundStatus.ready) {
                return const Text('About to start, get ready...');
              } else {
                return Text('Invalid round status: ${state.roundStatus}');
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
                      },
                      selected: state.selected,
                      correct: state.correct,
                    ),
                  ),
                  Builder(builder: (context) {
                    if (state.roundStatus == RoundStatus.answered) {
                      return Text(
                          'Please wait for the other players to finish up...');
                    } else if (state.roundStatus == RoundStatus.ready) {
                      return Column(
                        children: [
                          Builder(builder: (context) {
                            if (state.isWinner) {
                              return Text('Round winner!');
                            } else if (state.selected == state.correct) {
                              return Text(
                                  'Correct, but someone else was faster');
                            } else if (state.selected == -1) {
                              return Text('Too slow!');
                            } else {
                              return Text('Incorrect!');
                            }
                          }),
                          Builder(builder: (context) {
                            if (state.winner.length == 0) {
                              return Text('No winner this round');
                            } else if (state.winner.length == 1) {
                              return Text('Winner: ${state.winner[0]}');
                            } else {
                              return Text('Winner: ${state.winner}');
                            }
                          }),
                          Text('Please wait for next round...'),
                        ],
                      );
                    } else {
                      return Text('');
                    }
                  }),
                ],
              );
            } else if (state is GameCompleteState) {
              return Text('Please wait for results...');
            } else {
              return Text('Invalid state on question screen: $state');
            }
          },
        ),
      ),
    );
  }
}
