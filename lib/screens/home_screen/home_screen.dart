import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/screens/create_game_screen/create_game_screen.dart';
import 'package:max_trivia/screens/home_screen/bloc/home_bloc.dart';
import 'package:max_trivia/screens/join_game_screen/join_game_screen.dart';
import 'package:max_trivia/shared_widgets/buttons.dart';
import 'package:max_trivia/shared_widgets/shared_widgets.dart';
import 'package:max_trivia/utils/navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      child: Column(
        children: [
          ScreenButton(
            onPressed: () {
              newScreen(
                context: context,
                screen: const CreateGameScreen(),
              );
            },
            text: 'Host',
          ),
          ScreenButton(
            onPressed: () {
              newScreen(
                context: context,
                screen: const JoinGameScreen(),
              );
            },
            text: 'Join',
          ),
        ],
      ),
    );
  }
}
