import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    required this.label,
    required this.onChanged,
    required this.initialValue,
    Key? key,
  }) : super(key: key);

  final String label;
  final Function(String) onChanged;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    print('Initial text: $initialValue');
    final tc = TextEditingController()
      ..text = initialValue
      ..selection =
          TextSelection.fromPosition(TextPosition(offset: initialValue.length));

    return Row(
      children: [
        Text(label),
        SizedBox(
          width: 150,
          child: TextFormField(
            onChanged: onChanged,
            controller: tc,
          ),
        ),
      ],
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    required this.onPressed,
    required this.label,
    Key? key,
  }) : super(key: key);

  final Function() onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
