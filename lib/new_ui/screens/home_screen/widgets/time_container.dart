import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeContainer extends StatelessWidget {
  const TimeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return Container(
      width: 35.0,
      height: 54.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _theme.colorScheme.tertiaryContainer,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30.0),
          bottom: Radius.circular(30.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('dd').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              Text(
                DateFormat('E').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 11.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
