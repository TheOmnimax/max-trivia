part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    required this.roomCode,
    required this.playerId,
    required this.isHost,
    required this.username,
    this.loginStatus,
    this.loginDetails,
  });

  final String roomCode;
  final String playerId;
  final bool isHost;

  final String username;
  final LoginResult? loginStatus;
  final String? loginDetails;

  @override
  List<Object?> get props => [
        roomCode,
        playerId,
        isHost,
        username,
        loginStatus,
        loginDetails,
      ];

  AppState copyWith({
    String? roomCode,
    String? playerId,
    bool? isHost,
    String? username,
    LoginResult? loginStatus,
    String? loginDetails,
  }) {
    return AppState(
      roomCode: roomCode ?? this.roomCode,
      playerId: playerId ?? this.playerId,
      isHost: isHost ?? this.isHost,
      username: username ?? this.username,
      loginStatus: loginStatus,
      loginDetails: loginDetails,
    );
  }
}
