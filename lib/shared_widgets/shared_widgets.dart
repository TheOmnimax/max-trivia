import 'package:flutter/material.dart';

import 'loading.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(100, 211, 228, 242),
        body: Center(
          child: Container(
            // color: Color.fromARGB(100, 174, 211, 242),
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
