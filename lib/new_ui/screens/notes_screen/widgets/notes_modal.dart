import 'package:animations/animations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:tsec_app/models/class_model/class_model.dart';
import 'package:tsec_app/models/notes_model/notes_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/notes_dropdown_field.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/notes_text_field.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/notes_provider.dart';
import 'package:tsec_app/utils/profile_details.dart';

class NotesModal extends ConsumerStatefulWidget {
  Function action;
  NotesModel? note;
  Function uploadNoteCallback;
  GlobalKey<FormState> formKey;
  NotesModal({
    super.key,
    this.note,
    required this.action,
    required this.uploadNoteCallback,
    required this.formKey,
  });

  @override
  ConsumerState<NotesModal> createState() => _NotesModalState();
}

class _NotesModalState extends ConsumerState<NotesModal> {
  FilePickerResult? selectedFiles;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? year;
  String? branch;
  String? division;
  String? subject;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      NotesModel note = widget.note!;
      titleController.text = note.title;
      descriptionController.text = note.description;
      year = note.targetClasses[0].year;
      branch = note.targetClasses[0].branch;
      division = note.targetClasses[0].division;
      subject = note.subject;
    }
  }

  Future<void> pickFiles() async {
    FilePickerResult? results = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: true,
    );
    if (results != null) {
      debugPrint(results.toString());
      setState(() {
        if (selectedFiles == null) {
          selectedFiles = results;
        } else {
          selectedFiles?.files.addAll(results.files);
        }
      });
    } else {
      // User canceled the picker
    }
  }

  void deselectFile(PlatformFile file) {
    setState(() {
      selectedFiles!.files.remove(file);
    });
  }

  void openFile(String? filePath) {
    debugPrint("clicked");
    if (filePath != null) {
      OpenFile.open(filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NotesTextField(
                  editMode: !user!.isStudent,
                  label: "Title",
                  controller: titleController,
                  readOnly: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    // if (!isValidPhoneNumber(value)) {
                    //   return 'Please enter a valid phone number';
                    // }
                    return null;
                  },
                ),
                Divider(
                  height: 2,
                ),
                NotesTextField(
                  editMode: !user.isStudent,
                  label: "Description",
                  controller: descriptionController,
                  readOnly: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    // if (!isValidPhoneNumber(value)) {
                    //   return 'Please enter a valid phone number';
                    // }
                    return null;
                  },
                ),
                !user.isStudent
                    ? Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .3,
                            child: NotesDropdownField(
                              editMode: true,
                              label: "Year",
                              items: allYearList,
                              val: year,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a year';
                                }
                                return null;
                              },
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    year = newValue;
                                    division = null;
                                    subject = null;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .24,
                            child: NotesDropdownField(
                              editMode: year != null && branch != null,
                              label: "Div",
                              items: year != null && branch != null
                                  ? calcDivisionList(gradYear[year]!, branch!)
                                  : [],
                              val: division,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a division';
                                }
                                return null;
                              },
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    division = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .34,
                            child: NotesDropdownField(
                              editMode: true,
                              label: "Branch",
                              items: allBranchList,
                              val: branch,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a branch';
                                }
                                return null;
                              },
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    branch = newValue;
                                    division = null;
                                    subject = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Divider(
                  height: 2,
                ),
                NotesDropdownField(
                  editMode: year != null && branch != null && !user.isStudent,
                  label: "Subject",
                  items: subjects[year]?[branch]?[evenOrOddSem()] ?? [],
                  val: subject,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a subject';
                    }
                    return null;
                  },
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        subject = newValue;
                      });
                    }
                  },
                ),
                // Row(
                //   children: []0
                // ),
                SizedBox(height: 20),
                Divider(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attachments',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child: selectedFiles != null &&
                                selectedFiles!.files.length > 0
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selectedFiles?.files.length ?? 0,
                                itemBuilder: (context, index) {
                                  var file = selectedFiles!.files[index];
                                  return Container(
                                    width: 120,
                                    height: 10,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                      vertical: 2.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () => openFile(file.path),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              file.name,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          !user.isStudent
                                              ? GestureDetector(
                                                  onTap: () =>
                                                      deselectFile(file),
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  "No attachments added",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                !user.isStudent
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 11, 20, 11),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                    Theme.of(context).colorScheme.onBackground),
                                // You can customize other properties as needed
                                // textColor, elevation, padding, shape, etc.
                              ),
                              onPressed: () async {
                                await pickFiles();
                              },
                              child: Text('Attach',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                !user.isStudent
                    ? Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.note != null
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                    ),
                                    onPressed: () async {
                                      ref
                                          .read(notesProvider.notifier)
                                          .deleteNote(
                                              widget.note!.id!, context);
                                      widget.action.call();
                                    },
                                    child: Text('Delete',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                  )
                                : Container(),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer),
                                // You can customize other properties as needed
                                // textColor, elevation, padding, shape, etc.
                              ),
                              onPressed: () {
                                debugPrint(
                                    "inside notes modal clicked note id: ${widget.note?.id}");
                                widget.uploadNoteCallback(
                                    selectedFiles,
                                    widget.note?.id,
                                    titleController.text,
                                    descriptionController.text,
                                    subject,
                                    branch,
                                    division,
                                    year);
                              },
                              child: Text(
                                  widget.note == null ? 'Upload' : 'Save',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
