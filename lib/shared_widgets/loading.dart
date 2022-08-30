import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:max_trivia/constants/theme_data.dart';
import 'package:flutter/material.dart';

const bigLoading = SpinKitDualRing(
  color: themeColor,
);

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    required this.context,
    this.title = 'Loading...',
    this.children = const <Widget>[],
    Key? key,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = List<Widget>.from(children);
    c.insert(0, bigLoading);
    return SimpleDialog(
      title: Text(title),
      children: c,
    );
  }
}
