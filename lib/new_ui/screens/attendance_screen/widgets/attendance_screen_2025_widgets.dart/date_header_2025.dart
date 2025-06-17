/*
CONTAINS THE SCROLLABLE DATE PICKER IN THE ATTENDANCE SCREEN

*/

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/new_ui/colors.dart';

import '../../../../../screens/main_screen/widget/card_display.dart';

class DateHeader2025 extends ConsumerStatefulWidget {
  final double width;
  const DateHeader2025({super.key, required this.width});

  @override
  ConsumerState<DateHeader2025> createState() => _DateHeader2025State();
}

class _DateHeader2025State extends ConsumerState<DateHeader2025> {
  List dates = List.generate(30, (count) => count + 1);

  @override
  Widget build(BuildContext context) {
    // DateTime _selectedValue = DateTime.now();
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DatePicker(
            DateTime.now().subtract(const Duration(days: 30)),
            daysCount: 31,
            isReversed: true,
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
              // print(date.toIso8601String());
              ref.read(dayProvider.notifier).update(((state) => date));
              setState(() {
                // _selectedValue = date;
              });
            },
          ),
        ],
      ),
    );
  }
}
