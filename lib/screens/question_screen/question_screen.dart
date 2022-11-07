import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/screens/game_complete_screen/game_complete_screen.dart';
import 'package:max_trivia/screens/question_screen/bloc/question_bloc.dart';
import 'package:max_trivia/shared_widgets/buttons.dart';
import 'package:max_trivia/shared_widgets/shared_widgets.dart';
import 'package:max_trivia/utils/navigation.dart';

import '../../shared_widgets/loading.dart';

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
    return DefaultScaffold(
      child: BlocConsumer<QuestionBloc, QuestionState>(
        listener: (context, state) {
          if (state is GameCompleteState) {
            newScreen(
              context: context,
              screen: const GameCompleteScreen(),
            );
          } else if (state is LoadingState) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return LoadingDialog(context: context);
                });
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return Container();
          } else if (state is PregameState) {
            if (state.roundStatus == RoundStatus.answered) {
              if (context.read<AppBloc>().state.isHost) {
                return Column(
                  children: [
                    Row(
                      children: [
                        const Text('Room code: '),
                        SelectableText(
                          context.read<AppBloc>().state.roomCode.toUpperCase(),
                        ),
                      ],
                    ),
                    ScreenButton(
                      onPressed: () {
                        context.read<QuestionBloc>().add(
                              const StartGame(),
                            );
                      },
                      label: 'Start',
                    ),
                    Text('Players: ${state.players.join(', ')}'),
                  ],
                );
              } else {
                return GenericText(
                  'Please wait for host to start game...',
                  addLabels: ['Players: ${state.players.join(', ')}'],
                );
              }
            } else if (state.roundStatus == RoundStatus.ready) {
              return const GenericText('About to start, get ready...');
            } else {
              return Text('Invalid round status: ${state.roundStatus}');
            }
          } else if (state is PlayingState) {
            return Column(
              children: [
                Text(state.question),
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
                    switch (state.answerStatus) {
                      case AnswerStatus.waiting:
                        {
                          return const GenericText('Waiting for results...');
                        }
                      case AnswerStatus.answered:
                        {
                          return const GenericText(
                              'Please wait for the other players to finish up...');
                        }
                      case AnswerStatus.noAnswer:
                        {
                          return const GenericText('Round complete');
                        }
                      case AnswerStatus.winner:
                        {
                          return const GenericText('Winner!');
                        }
                      case AnswerStatus.correct:
                        {
                          return const GenericText(
                              'Correct, but someone else was faster!');
                        }
                      case AnswerStatus.incorrect:
                        {
                          return const GenericText('Incorrect!');
                        }
                      default:
                        {
                          return const GenericText(
                              'Unknown status when answered');
                        }
                    }
                  } else if (state.roundStatus == RoundStatus.ready) {
                    return Column(
                      children: [
                        Builder(builder: (context) {
                          if (state.isWinner) {
                            return const Text('Round winner!');
                          } else if (state.selected == state.correct) {
                            return const Text(
                                'Correct, but someone else was faster');
                          } else if (state.selected == -1) {
                            return const Text('Too slow!');
                          } else {
                            return const Text('Incorrect!');
                          }
                        }),
                        Builder(builder: (context) {
                          if (state.winner.isEmpty) {
                            return const Text('No winner this round');
                          } else if (state.winner.length == 1) {
                            return Text('Winner: ${state.winner[0]}');
                          } else {
                            return Text('Winner: ${state.winner}');
                          }
                        }),
                        const Text('Please wait for next round...'),
                      ],
                    );
                  } else {
                    return const Text('');
                  }
                }),
              ],
            );
          } else if (state is GameCompleteState) {
            return const Text('Please wait for results...');
          } else {
            return Text('Invalid state on question screen: $state');
          }
        },
      ),
    );
  }
}
