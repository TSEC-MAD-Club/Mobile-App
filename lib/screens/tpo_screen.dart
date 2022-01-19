import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class TPOScreen extends StatefulWidget {
  const TPOScreen({Key? key}) : super(key: key);

  @override
  _TPOScreenState createState() => _TPOScreenState();
}

class _TPOScreenState extends State<TPOScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const <Widget>[
          CustomAppBar(
            title: "Training & Placement Cell",
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
