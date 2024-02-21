import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/notes_model/notes_model.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/custom_pdf_icon.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/notes_modal.dart';
import 'package:tsec_app/provider/notes_provider.dart';
import 'package:tsec_app/utils/datetime.dart';

class NoteList extends ConsumerStatefulWidget {
  // final String subject;
  // final String noteTitle;
  // final String date;
  // final String noteContent;
  // final String pdfCount;
  // final String teacherName;

  Function uploadNote;
  GlobalKey<FormState> formKey;
  NoteList({
    super.key,
    required this.formKey,
    required this.uploadNote,
    // required this.subject,
    // required this.noteTitle,
    // required this.date,
    // required this.noteContent,
    // required this.pdfCount,
    // required this.teacherName,
  });

  @override
  ConsumerState<NoteList> createState() => _NoteListState();
}

class _NoteListState extends ConsumerState<NoteList> {
  bool _isVisible = false;

  void _toggleFilterVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  /* This method is for shortening the note content 
    written for 5 words, if needed more, just change the number
  */
  String _getFirst5Words(String content) {
    List<String> words = content.split(' ');
    if (words.length > 5) {
      return '${words.sublist(0, 5).join(' ')}...';
    } else {
      return content;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<NotesModel>> allNotes = ref.watch(notesProvider);
    List<DateTime> keys = allNotes.keys.toList();
    List<List<NotesModel>> values = allNotes.values.toList();
    // debugPrint(allNotes.toString());
    return SizedBox(
      height: MediaQuery.of(context).size.height * .7,
      child: ListView.builder(
        itemCount: allNotes.length,
        itemBuilder: (context, index) {
          DateTime ithDate = keys[index];
          List<NotesModel> ithNotesList = values[index];
          return Column(
            children: [
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(formatDate(ithDate),
                      style: TextStyle(color: Colors.grey))
                ],
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: ithNotesList.length,
                  itemBuilder: (context, i) {
                    List<String> attachments = ithNotesList[i]
                        .attachments
                        .map((e) => e.split("%2F")[1].split("?")[0])
                        .toList();
                    // debugPrint(attachments.toString());
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: OpenContainer(
                        transitionDuration: Duration(milliseconds: 500),
                        closedColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        closedBuilder: (context, action) {
                          return Container(
                            // margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${ithNotesList[i].subject}: ${ithNotesList[i].title}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    /* use can use the
                           _getFirst5Words method here if want to
                           _getFirst5Words(widget.noteContent)
                           method on line no. 40
                                                */
                                    ithNotesList[i].description,
                                    // widget.noteContent,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .8,
                                        height: 40,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                min(2, attachments.length),
                                            itemBuilder: (context, ind) {
                                              return CustomPdfIcon(
                                                pdfName: attachments[ind],
                                              );
                                            }),
                                      ),
                                      attachments.length > 2
                                          ? Text(
                                              "+${attachments.length - 2}",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        openBuilder: (context, action) {
                          return NotesModal(
                            action: action,
                            note: ithNotesList[i],
                            formKey: widget.formKey,
                            uploadNoteCallback:
                                (FilePickerResult? selectedFiles,
                                    String? id,
                                    String? title,
                                    String? description,
                                    String? subject,
                                    String? branch,
                                    String? division,
                                    String? year) {
                              if (widget.formKey.currentState!.validate()) {
                                widget.uploadNote(
                                    selectedFiles,
                                    id,
                                    title,
                                    description,
                                    subject,
                                    branch,
                                    division,
                                    year);
                                action.call();
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
