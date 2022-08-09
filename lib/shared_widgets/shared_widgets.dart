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
        body: child,
      ),
    );
  }
}

// class JoinStatusDisplay extends StatelessWidget {
//   const JoinStatusDisplay({
//     required this.joinStatus,
//     Key? key,
//   }) : super(key: key);
//
//   final JoinStatus joinStatus;
//
//   @override
//   Widget build(BuildContext context) {
//     if (joinStatus == JoinStatus.none) {
//       return Text('');
//     }
//     final String errorText;
//     if (joinStatus == JoinStatus.noName) {
//       errorText = 'Please '
//     }
//   }
// }
