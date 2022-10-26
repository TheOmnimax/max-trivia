import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_trivia/constants/constants.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const MainState()) {
    on<SocketConnect>(_homeStart);
  }

  void _homeStart(SocketConnect event, Emitter<HomeState> emit) {}
}
