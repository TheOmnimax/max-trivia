part of 'question_screen.dart';

class ChoiceWidget extends StatelessWidget {
  const ChoiceWidget({
    required this.choice,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String choice;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        choice,
        style: const TextStyle(fontSize: 30.0),
      ),
    );
  }
}
