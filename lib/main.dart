import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/bloc/app_bloc.dart';
import 'package:max_trivia/firebase_options.dart';
import 'package:max_trivia/screens/create_game_screen/create_game_screen.dart';
import 'package:max_trivia/screens/game_complete_screen/game_complete_screen.dart';
import 'package:max_trivia/screens/home_screen/home_screen.dart';
import 'package:max_trivia/screens/join_game_screen/join_game_screen.dart';
import 'package:max_trivia/screens/question_screen/question_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Running');
    return BlocProvider(
      create: (_) => AppBloc()..add(const AppOpened()),
      child: const Main(),
    );
  }
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Max Trivia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        // '/create-game': (context) => const CreateGameScreen(),
        // '/join-game': (context) => const JoinGameScreen(),
        // '/question-screen': (context) => const QuestionScreen(),
        // '/game-complete': (context) => const GameCompleteScreen()
      },
    );
  }
}
