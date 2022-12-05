import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/screens/create_game_screen/bloc/create_game_bloc.dart';
import 'package:max_trivia/screens/question_screen/question_screen.dart';
import 'package:max_trivia/shared_widgets/buttons.dart';
import 'package:max_trivia/shared_widgets/form_input.dart';
import 'package:max_trivia/shared_widgets/loading.dart';
import 'package:max_trivia/shared_widgets/shared_widgets.dart';

import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/utils/navigation.dart';

class CreateGameScreen extends StatelessWidget {
  const CreateGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateGameBloc(
        appBloc: context.read<AppBloc>(),
      ),
      child: const CreateGameMain(),
    );
  }
}

class CreateGameMain extends StatefulWidget {
  const CreateGameMain({Key? key}) : super(key: key);

  @override
  State<CreateGameMain> createState() => _CreateGameMainState();
}

class _CreateGameMainState extends State<CreateGameMain> {
  @override
  Widget build(BuildContext context) {
    String playerName = '';
    bool loading = false;

    void stopLoading() {
      if (loading) {
        loading = false;
        Navigator.pop(context);
      }
    }

    final createKey = GlobalKey<FormState>();

    return BlocListener<CreateGameBloc, CreateGameState>(
      listener: (context, state) {
        createKey.currentState!.validate();
        if (state is LoadingState) {
          newScreen(
            context: context,
            screen: const QuestionScreen(),
          );
        }
      },
      child: DefaultScaffold(
        child: Form(
          key: createKey,
          child: Column(
            children: [
              TextInput(
                label: 'Your name',
                onChanged: (String value) {
                  playerName = value;
                },
                initialValue: '',
                validator: (String? value) {
                  if (value == '') {
                    stopLoading();
                    return 'Please enter your name!';
                  } else if (context.read<CreateGameBloc>().state.joinStatus ==
                      JoinStatus.timedOut) {
                    stopLoading();
                    return 'Timed out. Please try again.';
                  }
                },
              ),
              ScreenButton(
                onPressed: () async {
                  createKey.currentState!.validate();
                  if (playerName != '') {
                    context.read<CreateGameBloc>().add(
                          CreateGame(
                            numRounds: 5, // NUMBER OF ROUNDS
                            categories: const ['19g8pnv6jujxzli9'],
                            playerName: playerName,
                          ),
                        );
                    loading = true;
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return LoadingDialog(context: context);
                        });
                  }
                },
                label: 'Create',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
