import 'dart:collection';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/models/class_model/class_model.dart';
import 'package:tsec_app/models/notes_model/notes_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/note_list.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/notes_filter.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/notes_modal.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/notes_provider.dart';
import 'package:tsec_app/utils/datetime.dart';
import 'package:tsec_app/utils/image_assets.dart';
import 'package:file_picker/file_picker.dart';

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
      FilePickerResult? selectedFiles,
      String? id,
      String? title,
      String? description,
      String? subject,
      String? branch,
      String? division,
      String? year) async {
    UserModel user = ref.read(userModelProvider)!;
    List<String> urls = await ref
        .watch(notesProvider.notifier)
        .uploadAttachments(selectedFiles);
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
      attachments: urls,
    );

    await ref.read(notesProvider.notifier).uploadNote(note, context);
  }

  Widget _buildNavigation(
    BuildContext context, {
    required VoidCallback onPressed,
    required Widget icon,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconTheme(
          data: const IconThemeData(color: Colors.black),
          child: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final brightness = Theme.of(context).brightness;
    // bool isItDarkMode = brightness == Brightness.dark;
    UserModel userModel = ref.watch(userModelProvider)!;

    // Map<DateTime, List<NotesModel>> allNotes = ref.watch(notesProvider);
    // debugPrint("parent, ${allNotes.toString()}");
    return Scaffold(
      floatingActionButton: !userModel.isStudent
          ? OpenContainer(
              transitionDuration: Duration(milliseconds: 500),
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
                    uploadNoteCallback: (FilePickerResult? selectedFiles,
                        String? id,
                        String? title,
                        String? description,
                        String? subject,
                        String? branch,
                        String? division,
                        String? year) {
                      if (_formKey.currentState!.validate()) {
                        uploadNote(selectedFiles, id, title, description,
                            subject, branch, division, year);
                        action.call();
                      }
                    });
              },
            )
          : Container(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
            SizedBox(height: 10,),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  // color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildNavigation(context,
                              icon: const Icon(Icons.chevron_left_rounded),
                              onPressed: () {
                            GoRouter.of(context).pop();
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Notes",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 177,
                            child: Image.asset(
                              ImageAssets.notes,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NotesFilterBar(),
              ),
              const SizedBox(
                height: 10,
              ),
              NoteList(
                // subject: _subjects[0],
                // noteTitle: _noteTitle[0],
                // date: _date[0],
                // noteContent: _noteContent[0],
                // pdfCount: _pdfCount[0],
                // teacherName: _teachersName[0],
                formKey: _formKey,
                uploadNote: uploadNote,
              ),
              const SizedBox(
                height: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
