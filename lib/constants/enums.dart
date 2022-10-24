enum LoginResult {
  success,
  disabled,
  invalidEmail,
  wrongPassword,
  weakPassword,
  missingEmail,
  missingPassword,
  missingReenter,
  passwordMismatch,
  notFound,
  usedUsername,
  brute,
  unknownError,
}

enum TriviaStatus {
  active,
  answered,
  waiting, // Time has run out
}

enum AnswerStatus {
  waiting, // No answer yet, still a chance to answer
  answered, // Selected a choice, but no response from server yet
  winner, // Won the round
  correct, // Correct, but not the best time, or don't know yet
  incorrect, // Incorrect response
  noAnswer, // Someone else selected before they could select one
}

enum RoundStatus {
  playing,
  answered, // Either already answered the question and waiting for the round to complete, or is the host, and ready to start the game
  ready, // Round is complete, waiting for the next round
}

enum JoinStatus {
  none,
  noName,
  noRoomCode,
  roomNotExists,
  joined,
  timedOut,
  unknown
}
