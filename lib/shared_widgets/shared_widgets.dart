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
        body: child,
      ),
    );
  }
}
