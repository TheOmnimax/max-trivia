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

enum CompleteStatus {
  answered, // Selected a choice, but no response from server yet
  winner, // Won the round
  correct, // Correct, but not the best time, or don't know yet
  incorrect, // Incorrect response
  noAnswer, // Someone else selected before they could select one
}
