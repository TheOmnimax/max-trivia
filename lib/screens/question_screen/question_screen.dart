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

  List<ChoiceWidget> _getChoiceWidgets(List<String> choices) {
    final choiceWidgets = <ChoiceWidget>[];

    for (final choice in choices) {
      choiceWidgets.add(ChoiceWidget(choice: choice));
    }

    return choiceWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<QuestionBloc, QuestionState>(
          builder: (context, state) {
            print(state);
            if (state is LoadingState) {
              return const Text('Loading...');
            } else if (state is PregameState) {
              if (context.read<AppBloc>().state.isHost) {
                return TextButton(onPressed: () {}, child: const Text('Start'));
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
                    children: _getChoiceWidgets(state.choices),
                  )
                ],
              );
            } else {
              return Text('Invalid state');
            }
          },
        ),
      ),
    );
  }
}
