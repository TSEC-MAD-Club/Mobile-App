import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/new_ui/colors.dart';

import '../../../../../models/subject_model/subject_model.dart';
import '../../../../../models/user_model/user_model.dart';
import '../../../../../provider/attendance_date_provider.dart';
import '../../../../../provider/auth_provider.dart';
import '../../../../../provider/subjects_provider.dart';
import '../../../../../utils/profile_details.dart';
import '../../attendance_totals_provider.dart';
import '../../firebase_attendance_button_pressed_2025.dart';

class AddSubjectDialog extends ConsumerStatefulWidget {
  final Function f;
  const AddSubjectDialog({super.key, required this.f});

  @override
  ConsumerState<AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends ConsumerState<AddSubjectDialog> {
  List<String> subjectsList = [];
  String selectedSubject = "";

  @override
  void initState() {
    SubjectModel subjects = ref.read(subjectsProvider);
    UserModel user = ref.read(userModelProvider)!;
    SemesterData semData = subjects.dataMap[
    "${calcGradYear(user.studentModel?.gradyear)}_${user.studentModel?.branch}"] ??
        SemesterData(even_sem: [], odd_sem: []);
    subjectsList = evenOrOddSem() == "even_sem" ? semData.even_sem : semData.odd_sem;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: commonbgblack,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add Subject",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                dropdownColor: commonbgL3ightblack,
                decoration: InputDecoration(
                  labelText: "Select Subject",
                  border: OutlineInputBorder(),
                ),
                items: subjectsList.map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedSubject = newValue;
                  }
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a subject';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),

              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (selectedSubject.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please select a subject"),
                          ),
                        );
                        return;
                      }
                      ref
                          .read(dateTimetablePreAbsCanProvider.notifier)
                          .addEntry(selectedSubject, 'Can');
                      await FirebaseAttendance2025().pressedCancelled(
                          ref.read(attendanceDateprovider), selectedSubject);
                      await Future.delayed(const Duration(milliseconds: 400));
                      ref.read(attendanceTotalsPerLectureProvider(selectedSubject).notifier)
                          .refresh();
                      ref.read(attendanceTotalsProvider.notifier).refresh();
                      widget.f();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Row(
                      spacing: 5,
                      children: [
                        Icon(
                          Icons.error_outline_outlined,
                          color: Colors.white,
                        ),
                        Text("Can")
                      ],
                    )),
                  GestureDetector(
                      onTap: () async {
                        if (selectedSubject.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please select a subject"),
                            ),
                          );
                          return;
                        }
                        ref
                            .read(dateTimetablePreAbsCanProvider.notifier)
                            .addEntry(selectedSubject, 'Pre');
                        await FirebaseAttendance2025().pressedPresent(
                            ref.read(attendanceDateprovider), selectedSubject);
                        await Future.delayed(const Duration(milliseconds: 400));
                        ref.read(attendanceTotalsPerLectureProvider(selectedSubject).notifier)
                            .refresh();
                        ref.read(attendanceTotalsProvider.notifier).refresh();
                        widget.f();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          Text("Pre")
                        ],
                      )),
                  GestureDetector(
                      onTap: () async {
                        if (selectedSubject.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please select a subject"),
                            ),
                          );
                          return;
                        }
                        ref
                            .read(dateTimetablePreAbsCanProvider.notifier)
                            .addEntry(selectedSubject, 'Abs');
                        await FirebaseAttendance2025().pressedAbsent(
                            ref.read(attendanceDateprovider), selectedSubject);
                        await Future.delayed(const Duration(milliseconds: 400));
                        ref.read(attendanceTotalsPerLectureProvider(selectedSubject).notifier)
                            .refresh();
                        ref.read(attendanceTotalsProvider.notifier).refresh();
                        widget.f();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          ),
                          Text("Abs")
                        ],
                      ))
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
    );
  }
}
