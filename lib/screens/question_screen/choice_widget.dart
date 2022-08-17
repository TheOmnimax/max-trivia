part of 'question_screen.dart';

class ChoiceWidget extends StatelessWidget {
  const ChoiceWidget({
    required this.choice,
    required this.onPressed,
    required this.choiceValue,
    required this.selected,
    required this.correct,
    Key? key,
  }) : super(key: key);

  final String choice;
  final Function() onPressed;
  final int choiceValue;
  final int selected;
  final int correct;

  @override
  Widget build(BuildContext context) {
    if ((selected == -1) && (correct == -1)) {
      // Still playing
      return TextButton(
        onPressed: onPressed,
        child: Text(
          choice,
          style: const TextStyle(
            fontSize: 30.0,
          ),
        ),
      );
    } else if ((selected == choiceValue) && (correct == choiceValue)) {
      // Player selected correct choice
      return Text(
        '$choice ✓', // TODO: Add better checkmark
        style: const TextStyle(
          fontSize: 30.0,
          backgroundColor: Colors.green,
        ),
      );
    } else if ((selected == -1) && (correct == choiceValue)) {
      // User did not select a choice, and this was the correct choice
      return Text(
        choice,
        style: const TextStyle(
          fontSize: 30.0,
          backgroundColor: Colors.grey,
        ),
      );
    } else if ((selected == choiceValue) && (correct == -1)) {
      // This was the selected choice, but we don't know the correct choice yet
      return Text(
        choice,
        style: const TextStyle(
          fontSize: 30.0,
          backgroundColor: Colors.lightGreenAccent,
        ),
      );
    } else if (selected == choiceValue) {
      // This was the selected choice, but it was wrong
      return Text(
        choice,
        style: const TextStyle(
          fontSize: 30.0,
          backgroundColor: Colors.redAccent,
        ),
      );
    } else if (correct == choiceValue) {
      return Text(
        choice,
        style: const TextStyle(
          fontSize: 30.0,
          backgroundColor: Colors.green,
        ),
      );
    } else {
      return Text(
        choice,
        style: const TextStyle(
          fontSize: 30.0,
        ),
      );
    }
  }
}
