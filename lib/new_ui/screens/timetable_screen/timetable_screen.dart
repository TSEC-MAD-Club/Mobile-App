// ignore_for_file: deprecated_member_use, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/screens/departmentlist_screen/department_list.dart';
import 'package:tsec_app/new_ui/screens/timetable_screen/widgets/card_display.dart';
import 'package:tsec_app/utils/notification_type.dart';
import 'package:tsec_app/utils/timetable_util.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';
import 'package:intl/intl.dart';

class TimeTable extends ConsumerWidget {
  const TimeTable({Key? key}) : super(key: key);

  static const colorList = [Colors.red, Colors.teal, Colors.blue];
  static const opacityList = [
    Color.fromRGBO(255, 0, 0, 0.2),
    Color.fromARGB(51, 0, 255, 225),
    Color.fromARGB(51, 0, 153, 255),
  ];

  static const _sidePadding = EdgeInsets.symmetric(horizontal: 15);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _size = MediaQuery.of(context).size;
    var _theme = Theme.of(context);
    var _boxshadow = BoxShadow(
      color: _theme.primaryColorDark,
      spreadRadius: 1,
      blurRadius: 2,
      offset: const Offset(0, 1),
    );
    UserModel? data = ref.watch(userModelProvider);

    if (data != null) {
      NotificationType.makeTopic(ref, data.studentModel);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (data == null)
          //   Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: Text(
          //       "Department",
          //       style: Theme.of(context)
          //           .textTheme
          //           .headlineLarge!
          //           .copyWith(fontSize: 44),
          //     ),
          //   )
          // else
          //   Padding(
          //     padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
          //     child: Text(
          //       "Schedule",
          //       style: Theme.of(context)
          //           .textTheme
          //           .headlineLarge!
          //           .copyWith(fontSize: 44),
          //     ),
          //   ),
          if (data == null)
            const DepartmentList()
          else
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: _size.width * 0.9,
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: DatePicker(
                    DateTime.now(),
                    monthTextStyle: _theme.textTheme.headlineSmall!.copyWith(
                      fontSize: 15,
                      color: _theme.colorScheme.onTertiary,
                    ),
                    dayTextStyle: _theme.textTheme.headlineSmall!.copyWith(
                      fontSize: 15,
                      color: _theme.colorScheme.onTertiary,
                    ),
                    dateTextStyle: _theme.textTheme.titleSmall!.copyWith(
                      fontSize: 15,
                      color: _theme.colorScheme.onTertiary,
                    ),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: _theme.colorScheme.onSecondary,
                    selectedTextColor: _theme.colorScheme.tertiaryContainer,
                    onDateChange: (selectedDate) {
                      ref
                          .read(dayProvider.notifier)
                          .update((state) => selectedDate);
                    },
                  ),
                ),
              ),
            ),
          if (data != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                  height: MediaQuery.of(context).size.height * .50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: _theme.colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ref.watch(dayProvider) != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
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
                                      DateFormat('dd')
                                          .format(ref.watch(dayProvider)),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('E')
                                          .format(ref.watch(dayProvider)),
                                      style: const TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      const Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: CardDisplay(),
                      )),
                    ],
                  )),
            )
          else
            Container(),
        ],
      ),
    );
  }
}
