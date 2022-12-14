import 'package:flutter/material.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/screens/question_screen/bloc/question_bloc.dart';
import 'package:max_trivia/shared_widgets/shared_widgets.dart';

import 'package:max_trivia/screens/question_screen/question_screen.dart';

class ChoicePageTest extends StatelessWidget {
  const ChoicePageTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ChoiceWidget> getChoiceWidgets({
      required List<String> choices,
      required Function(int) onSelected,
      int selected = -1,
      int correct = -1,
      bool winner = false,
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
            winner: winner,
          ),
        );
      }

      return choiceWidgets;
    }

    const state = PlayingState(
      players: [],
      score: {},
      roundNum: 0,
      question: 'Test question',
      choices: [
        'Choice 1',
        'This is a really long choice that is supposed to go onto the next line.',
        'Choice 3',
        'Choice 4'
      ],
      selected: -1,
      correct: 1,
      answerStatus: AnswerStatus.noAnswer,
      roundStatus: RoundStatus.playing,
    );

    return DefaultScaffold(
      child: Column(
        children: [
          Text(state.question),
          Column(
            children: getChoiceWidgets(
              choices: state.choices,
              onSelected: (int value) {},
              selected: state.selected,
              correct: state.correct,
            ),
          ),
          Builder(builder: (context) {
            if (state.roundStatus == RoundStatus.answered) {
              return const Text(
                  'Please wait for the other players to finish up...');
            } else {
              return const Text('');
            }
          }),
        ],
      ),
    );
  }
}
