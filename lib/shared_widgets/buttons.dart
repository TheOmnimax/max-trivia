import 'package:flutter/material.dart';

class ScreenButton extends StatelessWidget {
  const ScreenButton({
    required this.onPressed,
    required this.label,
    Key? key,
  }) : super(key: key);

  final Function() onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 45,
        width: 90,
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Lexend Deca',
            ),
          ),
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Color.fromARGB(100, 158, 208, 240),
          ),
        ),
      ),
    );
  }
}
