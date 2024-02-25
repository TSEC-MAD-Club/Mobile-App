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
                  uploadNoteCallback: (FilePickerResult? selectedFiles,
                      String? id,
                      String? title,
                      String? description,
                      String? subject,
                      String? branch,
                      String? division,
                      String? year) {
                    if (_formKey.currentState!.validate()) {
                      uploadNote(selectedFiles, id, title, description, subject,
                          branch, division, year);
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
            NotesFilterBar(),
            NoteList(
              formKey: _formKey,
              uploadNote: uploadNote,
            ),
          ],
          // headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          //   return <Widget>[
          //     SliverAppBar(
          //       leading: _buildNavigation(context,
          //           icon: const Icon(Icons.chevron_left_rounded),
          //           onPressed: () {
          //         GoRouter.of(context).pop();
          //       }),
          //       // actions: [
          //       //   _buildNavigation(context,
          //       //       icon: const Icon(Icons.chevron_left_rounded),
          //       //       onPressed: () {
          //       //     GoRouter.of(context).pop();
          //       //   }),
          //       // ],
          //       backgroundColor: Colors.transparent,
          //       floating: false,
          //       pinned: false,
          //       expandedHeight: 200.0, // Adjust the height as needed
          //       flexibleSpace: FlexibleSpaceBar(
          //         background: Padding(
          //           padding: const EdgeInsets.all(10.0),
          //           child: Row(
          //             children: [
          //               Expanded(
          //                 child: Text(
          //                   "Notes",
          //                   style: Theme.of(context)
          //                       .textTheme
          //                       .headlineLarge!
          //                       .copyWith(color: Colors.white),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 177,
          //                 child: Image.asset(
          //                   ImageAssets.notes,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     SliverToBoxAdapter(
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: NotesFilterBar(),
          //       ),
          //     ),
          //   ];
          // },
          // body: NoteList(
          //   // subject: _subjects[0],
          //   // noteTitle: _noteTitle[0],
          //   // date: _date[0],
          //   // noteContent: _noteContent[0],
          //   // pdfCount: _pdfCount[0],
          //   // teacherName: _teachersName[0],
          //   formKey: _formKey,
          //   uploadNote: uploadNote,
          // ),
        ),
      ),
    );
  }
}

class CustomSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  CustomSliverAppBar({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: NotesFilterBar(),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
