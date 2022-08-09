import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/screens/create_game_screen/bloc/create_game_bloc.dart';
import 'package:max_trivia/shared_widgets/form_input.dart';
import 'package:max_trivia/shared_widgets/shared_widgets.dart';

import '../../bloc/app_bloc.dart';

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
    return BlocListener<CreateGameBloc, CreateGameState>(
      listener: (context, state) {
        if (state is LoadingState) {
          Navigator.pushNamed(context, '/question-screen');
        }
      },
      child: DefaultScaffold(
        child: Column(
          children: [
            TextInput(
                label: 'Your name',
                onChanged: (String value) {
                  playerName = value;
                },
                initialValue: ''),
            ConfirmButton(
                onPressed: () {
                  context.read<CreateGameBloc>().add(
                        CreateGame(
                          numRounds: 5,
                          categories: ['19g8pnv6jujxzli9'],
                          playerName: playerName,
                        ),
                      );
                },
                label: 'Create')
          ],
        ),
      ),
    );
  }
}
