import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';

class CommittessScreen extends StatefulWidget {
  const CommittessScreen({Key? key}) : super(key: key);

  @override
  _CommittessScreenState createState() => _CommittessScreenState();
}

class _CommittessScreenState extends State<CommittessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const CustomAppBar(
            title: "Committees & Events",
          ),
        ],
      ),
    );
  }
}
