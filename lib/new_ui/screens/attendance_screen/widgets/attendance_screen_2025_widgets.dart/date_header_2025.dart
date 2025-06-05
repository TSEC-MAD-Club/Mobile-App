/*
CONTAINS THE SCROLLABLE DATE PICKER IN THE ATTENDANCE SCREEN

*/


import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/new_ui/colors.dart';

class DateHeader2025 extends StatefulWidget {
  final double width;
  const DateHeader2025({super.key, required this.width});

  @override
  State<DateHeader2025> createState() => _DateHeader2025State();
}

class _DateHeader2025State extends State<DateHeader2025> {
  List dates = List.generate(30, (count) => count + 1);

  @override
  Widget build(BuildContext context) {
    DateTime _selectedValue = DateTime.now();
    var theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DatePicker(
          DateTime(2025, 5, 1),
          initialSelectedDate: DateTime.now(),
          monthTextStyle: theme.textTheme.headlineSmall!.copyWith(
            fontSize: 11,
            color: Colors.grey,
          ),
          dayTextStyle: theme.textTheme.headlineSmall!.copyWith(
            fontSize: 11,
            color: Colors.grey,
          ),
          dateTextStyle: theme.textTheme.titleSmall!.copyWith(
            fontSize: 11,
            color: Colors.grey,
          ),
          selectionColor: oldDateSelectBlue,
          selectedTextColor: Colors.white,
          onDateChange: (date) {
            // New date selected
            setState(() {
              _selectedValue = date;
            });
          },
        ),
      ],
    );
  }
}
