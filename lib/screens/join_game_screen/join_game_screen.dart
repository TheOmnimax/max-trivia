import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/constants/constants.dart';
import 'package:max_trivia/screens/question_screen/question_screen.dart';
import 'package:max_trivia/shared_widgets/form_input.dart';
import 'package:max_trivia/shared_widgets/shared_widgets.dart';

import 'package:max_trivia/utils/navigation.dart';
import '../../shared_widgets/loading.dart';
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
    bool loading = false; // Is this the best way to do this?
    final joinKey = GlobalKey<FormState>();

    void stopLoading() {
      print('Loading: $loading');
      if (loading) {
        loading = false;
        print('Popping');
        Navigator.pop(context);
      }
    }

    return BlocListener<JoinGameBloc, JoinGameState>(
      listener: (context, state) {
        joinKey.currentState!.validate();
        if (state is LoadingState) {
          context.read<AppBloc>().add(
                AddGameInfo(
                  playerName: state.playerName,
                  roomCode: state.roomCode,
                  playerId: state.playerId,
                  isHost: false,
                ),
              );
          newScreen(
            context: context,
            screen: const QuestionScreen(),
          );
        }
      },
      child: DefaultScaffold(
        child: Form(
          key: joinKey,
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
                    stopLoading();
                    return 'Room code cannot be blank!';
                  } else {
                    final joinGameState = context.read<JoinGameBloc>().state;
                    print(joinGameState.joinStatus);
                    final joinStatus = joinGameState.joinStatus;
                    if (joinGameState.joinStatus == JoinStatus.roomNotExists) {
                      stopLoading();
                      return 'Room not found';
                    } else if (joinStatus == JoinStatus.timedOut) {
                      stopLoading();
                      return 'Timed out. Please try again.';
                    }
                  }
                },
              ),
              ConfirmButton(
                onPressed: () async {
                  context.read<JoinGameBloc>().add(
                        JoinGame(
                          name: name,
                          roomCode: roomCode,
                        ),
                      );
                  joinKey.currentState!.validate();
                  loading = true;
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return LoadingDialog(context: context);
                      });
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
