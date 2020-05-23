import 'package:flutter/material.dart';

class WorkingScreen extends StatefulWidget {
  static const route = '/workingScreen';

  const WorkingScreen({Key key}) : super(key: key);

  @override
  _WorkingScreen createState() => _WorkingScreen();
}

class _WorkingScreen extends State<WorkingScreen> {
  @override
  Widget build(BuildContext context) {
    return Text('HELLO');
  }
}
