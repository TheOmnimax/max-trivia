import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/shared_widgets/form_input.dart';
import 'package:max_trivia/shared_widgets/shared_widgets.dart';

import 'bloc/join_game_bloc.dart';

class JoinGameScreen extends StatelessWidget {
  const JoinGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: JoinGameMain(),
      create: (context) => JoinGameBloc(),
    );
  }
}

class JoinGameMain extends StatefulWidget {
  const JoinGameMain({Key? key}) : super(key: key);

  @override
  State<JoinGameMain> createState() => _JoinGameMainState();
}

class _JoinGameMainState extends State<JoinGameMain> {
  @override
  Widget build(BuildContext context) {
    String name = '';
    String roomCode = '';
    final _nameKey = GlobalKey<FormState>();

    return BlocListener<JoinGameBloc, JoinGameState>(
      listener: (context, state) {
        if (state is JoiningState) {
        } else if (state is LoadingState) {
          context.read<AppBloc>().add(
                AddGameInfo(
                  playerName: state.playerName,
                  roomCode: state.roomCode,
                  playerId: state.playerId,
                  isHost: false,
                ),
              );
        }
      },
      child: DefaultScaffold(
        child: Form(
          key: _nameKey,
          child: Column(
            children: [
              TextInput(
                label: 'Name',
                onChanged: (String value) {
                  name = value;
                },
                validator: (String? value) {
                  if (value == '') {
                    return 'Name cannot be blank!';
                  }
                },
              ),
              TextInput(
                label: 'Room code',
                onChanged: (String value) {
                  roomCode = value;
                },
                validator: (String? value) {
                  if (value == '') {
                    return 'Room code cannot be blank!';
                  } else {
                    context.read<JoinGameBloc>().add(
                          JoinGame(
                            name: name,
                            roomCode: roomCode,
                          ),
                        );
                    if (context.read<JoinGameBloc>().state.joinStatus ==
                        JoinStatus.roomNotExists) {
                      return 'Room not found';
                    }
                    Navigator.pushNamed(context, '/question-screen');
                  }
                },
              ),
              ConfirmButton(
                onPressed: () {
                  print('About to confirm');
                  print(_nameKey);
                  print(_nameKey.currentState);
                  if (_nameKey.currentState!.validate()) {}
                },
                label: 'Join',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
