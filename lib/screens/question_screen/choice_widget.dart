part of 'question_screen.dart';

class ChoiceBox extends StatelessWidget {
  const ChoiceBox({
    required this.label,
    this.backgroundColor = const Color.fromARGB(100, 222, 222, 222),
    // this.backgroundColor = Colors.black,
    this.additionalChildren,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final String label;
  final Color? backgroundColor;
  final List<Widget>? additionalChildren;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final textWidget = Flexible(
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 30.0,
        ),
      ),
    );
    final children = <Widget>[textWidget];
    if (additionalChildren != null) {
      children.addAll(additionalChildren!);
    }

    final container = Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        color: backgroundColor,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: children,
          ),
        ),
      ),
    );

    final Widget child;
    if (onPressed == null) {
      return container;
    } else {
      return TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: container,
      );
    }
  }
}

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
      return ChoiceBox(
        label: choice,
        onPressed: onPressed,
      );
    } else if ((selected == choiceValue) && (correct == choiceValue)) {
      // Player selected correct choice

      return ChoiceBox(
        backgroundColor: Colors.green,
        label: choice,
        additionalChildren: [Icon(Icons.check)],
      );
    } else if ((selected == -1) && (correct == choiceValue)) {
      // User did not select a choice, and this was the correct choice
      return ChoiceBox(
        label: choice,
        backgroundColor: Colors.grey,
      );
    } else if ((selected == choiceValue) && (correct == -1)) {
      // This was the selected choice, but we don't know the correct choice yet
      return ChoiceBox(
        label: choice,
        backgroundColor: Colors.lightGreenAccent,
      );
    } else if (selected == choiceValue) {
      // This was the selected choice, but it was wrong
      return ChoiceBox(
        label: choice,
        backgroundColor: Colors.redAccent,
      );
    } else if (correct == choiceValue) {
      return ChoiceBox(
        label: choice,
        backgroundColor: Colors.green,
      );
    } else {
      return ChoiceBox(
        label: choice,
      );
    }
  }
}
