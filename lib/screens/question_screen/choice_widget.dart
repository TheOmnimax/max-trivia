part of 'question_screen.dart';

class ChoiceWidget extends StatelessWidget {
  const ChoiceWidget({
    required this.choice,
    Key? key,
  }) : super(key: key);

  final String choice;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(choice),
    );
  }
}
