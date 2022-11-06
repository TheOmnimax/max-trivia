import 'package:flutter/material.dart';

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
              padding: const EdgeInsets.all(0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class GenericText extends StatelessWidget {
  const GenericText(
    this.label, {
    this.addLabels = const <String>[],
    Key? key,
  }) : super(key: key);

  final String label;
  final List<String> addLabels;

  @override
  Widget build(BuildContext context) {
    final textWidgets = <Widget>[Text(label)];

    for (final l in addLabels) {
      textWidgets.add(Text(l));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: textWidgets,
    );
  }
}
