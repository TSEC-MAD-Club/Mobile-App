import 'dart:collection';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/models/class_model/class_model.dart';
import 'package:tsec_app/models/notes_model/notes_model.dart';
import 'package:tsec_app/models/subject_model/subject_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/note_list.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/notes_filter.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/notes_modal.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/provider/notes_provider.dart';
import 'package:tsec_app/provider/subjects_provider.dart';
import 'package:tsec_app/utils/datetime.dart';
import 'package:tsec_app/utils/image_assets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tsec_app/utils/profile_details.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

//  Line 309, Write Firebase uploading logic
// Line 649, firebase collection parameters (means this parameters are required,
// you can add extra if you want)

class _NotesScreenState extends ConsumerState<NotesScreen> {
  // used for handeling blurr effect

  final _formKey = GlobalKey<FormState>();
  void uploadNote(
      List<String> newFiles,
      List<String> deletedFiles,
      List<String> originalFiles,
      String? id,
      String? title,
      String? description,
      String? subject,
      String? branch,
      String? division,
      String? year) async {
    UserModel user = ref.read(userModelProvider)!;
    NotesModel note = NotesModel(
      id: id ?? "",
      // title: titleController.text,
      title: title!,
      // description: descriptionController.text,
      description: description!,
      time: dmyDate(DateTime.now()),
      subject: subject!,
      professorName: user.facultyModel!.name,
      targetClasses: [
        ClassModel(branch: branch!, division: division!, year: year!)
      ],
      attachments: originalFiles,
    );
    if (_formKey.currentState!.validate()) {
      await ref
          .read(notesProvider.notifier)
          .uploadNote(note, newFiles, deletedFiles, context);
    }
  }

  Widget _buildNavigation(
    BuildContext context, {
    required VoidCallback onPressed,
    required Widget icon,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(0),
          // height: 10,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconTheme(
            data: const IconThemeData(color: Colors.black),
            child: icon,
          ),
        ),
      ),
    );
  }

  DateTime? filterStartDate;
  DateTime? filterEndDate;
  bool filterLatest = true;
  List<String> filterSelectedSubjects = [];
  String searchQuery = "";

  void changeFilters(DateTime? startDate, DateTime? endDate, bool latest,
      List<String> subjects) {
    setState(() {
      filterStartDate = startDate;
      filterEndDate = endDate;
      filterLatest = latest;
      filterSelectedSubjects = subjects;
    });
  }

  void clearAllFilters() {
    setState(() {
      UserModel user = ref.read(userModelProvider)!;
      SubjectModel subjects = ref.read(subjectsProvider);
      filterStartDate = null;
      filterEndDate = null;
      filterLatest = true;
      SemesterData semData = subjects.dataMap[
              "${calcGradYear(user.studentModel?.gradyear)}_${user.studentModel?.branch}"] ??
          SemesterData(even_sem: [], odd_sem: []);
      filterSelectedSubjects =
          evenOrOddSem() == "even_sem" ? semData.even_sem : semData.odd_sem;
    });
  }

  @override
  void initState() {
    SubjectModel subjects = ref.read(subjectsProvider);
    UserModel user = ref.read(userModelProvider)!;
    SemesterData semData = subjects.dataMap[
            "${calcGradYear(user.studentModel?.gradyear)}_${user.studentModel?.branch}"] ??
        SemesterData(even_sem: [], odd_sem: []);
    filterSelectedSubjects =
        evenOrOddSem() == "even_sem" ? semData.even_sem : semData.odd_sem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = ref.watch(userModelProvider)!;
    return Scaffold(
      floatingActionButton: !userModel.isStudent
          ? OpenContainer(
              transitionDuration: const Duration(milliseconds: 500),
              // closedColor: Theme.of(context).colorScheme.secondary,
              closedColor: Colors.transparent,
              closedShape: const CircleBorder(),
              closedBuilder: (context, action) {
                return FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.outline,
                  onPressed: () {
                    action.call();
                  },
                  tooltip: 'Add Notes',
                  child: const Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                );
              },
              openBuilder: (context, action) {
                return NotesModal(
                  action: action,
                  formKey: _formKey,
                  uploadNoteCallback: (List<String> selectedFiles,
                      List<String> deletedFiles,
                      List<String> originalFiles,
                      String? id,
                      String? title,
                      String? description,
                      String? subject,
                      String? branch,
                      String? division,
                      String? year) {
                    if (_formKey.currentState!.validate()) {
                      uploadNote(selectedFiles, deletedFiles, originalFiles, id,
                          title, description, subject, branch, division, year);
                      action.call();
                    }
                  },
                );
              },
            )
          : Container(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: _buildNavigation(
                context,
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: () {
                  GoRouter.of(context).pop();
                },
              ),
              backgroundColor: Colors.transparent,
              floating: false,
              pinned: false,
              expandedHeight: 200.0, // Adjust the height as needed
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Notes",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(
                        width: 177,
                        child: Image.asset(
                          ImageAssets.notes,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            NotesFilterBar(
              searchQuery: searchQuery,
              modifySearchQuery: (String newQuery) {
                setState(() {
                  searchQuery = newQuery;
                });
              },
              startDate: filterStartDate,
              endDate: filterEndDate,
              latest: filterLatest,
              subjects: filterSelectedSubjects,
              changeFilters: (DateTime? startDate, DateTime? endDate,
                  bool latest, List<String> subjects) {
                changeFilters(startDate, endDate, latest, subjects);
              },
              clearAllFilters: clearAllFilters,
            ),
            NoteList(
              formKey: _formKey,
              searchQuery: searchQuery,
              uploadNoteCallback: uploadNote,
              startDate: filterStartDate,
              endDate: filterEndDate,
              latest: filterLatest,
              subjects: filterSelectedSubjects,
            ),
          ],
        ),
      ),
    );
  }
}
