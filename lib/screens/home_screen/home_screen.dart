import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/screens/home_screen/bloc/home_bloc.dart';
import 'package:max_trivia/shared_widgets/buttons.dart';
import 'package:max_trivia/shared_widgets/shared_widgets.dart';

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
              Navigator.pushNamed(context, '/create-game');
            },
            text: 'Host',
          ),
          ScreenButton(
            onPressed: () {},
            text: 'Join',
          ),
        ],
      ),
    );
  }
}
