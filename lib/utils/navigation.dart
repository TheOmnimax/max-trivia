import 'package:flutter/material.dart';

void newScreen({
  required BuildContext context,
  required Widget screen,
}) {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (context) => screen,
    ),
  );
}
