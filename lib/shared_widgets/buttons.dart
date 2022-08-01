import 'package:flutter/material.dart';

class ScreenButton extends StatelessWidget {
  const ScreenButton({
    required this.onPressed,
    required this.text,
    Key? key,
  }) : super(key: key);

  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
