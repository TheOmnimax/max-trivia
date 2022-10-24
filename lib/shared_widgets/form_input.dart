import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    required this.label,
    required this.onChanged,
    this.initialValue = '',
    this.validator,
    Key? key,
  }) : super(key: key);

  final String label;
  final Function(String) onChanged;
  final String initialValue;
  final String? Function(String?)? validator;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    final initialValue = widget.initialValue;
    final tc = TextEditingController()
      ..text = initialValue
      ..selection =
          TextSelection.fromPosition(TextPosition(offset: initialValue.length));
    return Row(
      children: [
        Text(widget.label),
        SizedBox(
          width: 200,
          child: TextFormField(
            onChanged: widget.onChanged,
            controller: tc,
            validator: widget.validator,
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
