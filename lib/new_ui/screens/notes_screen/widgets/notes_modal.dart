import 'package:animations/animations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:tsec_app/models/class_model/class_model.dart';
import 'package:tsec_app/models/notes_model/notes_model.dart';
import 'package:tsec_app/models/subject_model/subject_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/colors.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/download_button.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/notes_dropdown_field.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/notes_text_field.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/notes_provider.dart';
import 'package:tsec_app/provider/subjects_provider.dart';
import 'package:tsec_app/utils/profile_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class NotesModal extends ConsumerStatefulWidget {
  Function action;
  NotesModel? note;
  void Function(
      List<String> selectedFiles,
      List<String> deletedFiles,
      List<String> originalFiles,
      String? id,
      String? title,
      String? description,
      String? subject,
      String? branch,
      String? division,
      String? year) uploadNoteCallback;
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
  // FilePickerResult? selectedFiles;
  List<String> attachments = [];
  List<String> newAttachments = [];
  List<String> deletedAttachments = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? year;
  String? branch;
  String? division;
  String? subject;

  void initFunc() async {
    if (widget.note != null) {
      NotesModel note = widget.note!;
      titleController.text = note.title;
      descriptionController.text = note.description;
      year = note.targetClasses[0].year;
      branch = note.targetClasses[0].branch;
      division = note.targetClasses[0].division;
      subject = note.subject;
      attachments = widget.note?.attachments ?? [];
      // List<PlatformFile> f = await downloadAndConvertFiles(note.attachments);
      // debugPrint(f.toString());
      // selectedFiles = FilePickerResult(f);
    }
  }

  @override
  void initState() {
    super.initState();
    initFunc();
    MapsYear.mapGradYear();
  }

  // Future<List<PlatformFile>> downloadAndConvertFiles(List<String> urls) async {
  //   List<PlatformFile> platformFiles = [];
  //
  //   for (String url in urls) {
  //     try {
  //       Dio dio = Dio();
  //       Response response = await dio.get(url);
  //
  //       if (response.statusCode == 200) {
  //         // Get the temporary directory using the path_provider package
  //         debugPrint("yea");
  //         Directory tempDir = await getTemporaryDirectory();
  //         String tempPath = tempDir.path;
  //       String name = url.split("%2F")[1].split("?")[0];
  //         debugPrint("yeah");
  //         // Create a temporary file to save the downloaded data
  //         File tempFile =
  //             File('$tempPath/name');
  //         await tempFile.writeAsBytes(response.data, flush: true);
  //
  //         debugPrint("yeahh");
  //         // Convert the File to PlatformFile
  //         PlatformFile platformFile = PlatformFile(
  //           name: name, // Set a name for the file
  //           path: tempFile.path,
  //           bytes: tempFile.readAsBytesSync(),
  //           size: 0,
  //         );
  //
  //         debugPrint("yeaadskljf");
  //         platformFiles.add(platformFile);
  //       } else {
  //         // Handle error
  //         print('Failed to download file from $url');
  //       }
  //     } catch (e) {
  //       // Handle exception
  //       print('Error: $e');
  //     }
  //   }
  //
  //   return platformFiles;
  // }

  Future<void> pickFiles() async {
    FilePickerResult? results = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: true,
    );
    if (results != null) {
      List<String> resultFiles =
          results.files.map((e) => e.path ?? "").toList();
      // debugPrint(results.toString());
      setState(() {
        attachments = [...attachments, ...resultFiles];
        debugPrint("new attachments: ${attachments.toString()}");
        newAttachments = [...newAttachments, ...resultFiles];
        // if (selectedFiles == null) {
        //   selectedFiles = results;
        // } else {
        //   selectedFiles?.files.addAll(results.files);
        // }
      });
    } else {
      // User canceled the picker
    }
  }

  void deselectFile(int index) {
    setState(() {
      String file = attachments[index];
      // selectedFiles!.files.remove(file);
      attachments = attachments.where((f) => f != file).toList();
      // attachments.removeAt(index);
      debugPrint(attachments.toString());
      if (!newAttachments.contains(file))
        deletedAttachments = [...deletedAttachments, file];
      newAttachments = newAttachments.where((f) => f != file).toList();
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
    print("Inside NotesModal");
    UserModel user = ref.watch(userModelProvider)!;

    SubjectModel subjects = ref.read(subjectsProvider);
    SemesterData semData = subjects.dataMap["${year}_${branch}"] ??
        SemesterData(even_sem: [], odd_sem: []);
    List<String> allSubjects =
        evenOrOddSem() == "even_sem" ? semData.even_sem : semData.odd_sem;

    final scrollController = ScrollController();
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF1B1B1B),
        title: Text(
          "Note",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Form(
            key: widget.formKey,
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: !user.isStudent
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
                  children: [
                    // Center(
                    //   child: ,
                    // ),
                    SizedBox(
                      height: user.isStudent ? 10 : 0,
                    ),
                    NotesTextField(
                      editMode: !user.isStudent,
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
                    SizedBox(
                      height: user.isStudent ? 0 : 0,
                    ),
                    user.isStudent
                        ? Divider(
                            height: 1,
                            color: Theme.of(context).colorScheme.outline,
                          )
                        : Container(),
                    SizedBox(
                      height: user.isStudent ? 20 : 0,
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
                                width: MediaQuery.of(context).size.width * .4,
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .26,
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
                                width: MediaQuery.of(context).size.width * .25,
                                child: NotesDropdownField(
                                  editMode: year != null && branch != null,
                                  label: "Div",
                                  items: year != null && branch != null
                                      ? calcDivisionList(
                                          gradYearMapping[year]!, branch!)
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
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: user.isStudent ? 0 : 0,
                    ),
                    user.isStudent
                        ? Divider(
                            height: 1,
                            color: Theme.of(context).colorScheme.outline,
                          )
                        : Container(),
                    SizedBox(
                      height: user.isStudent ? 20 : 0,
                    ),
                    NotesDropdownField(
                      editMode:
                          year != null && branch != null && !user.isStudent,
                      label: "Subject",
                      // items: subjects[year]?[branch]?[evenOrOddSem()] ?? [],
                      items: allSubjects,
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
                    SizedBox(
                      height: user.isStudent ? 10 : 0,
                    ),
                    user.isStudent
                        ? Divider(
                            height: 1,
                            color: Theme.of(context).colorScheme.outline,
                          )
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 11, 20, 11),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.attachment,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Attachments",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // widget.note != null
                          // ? SizedBox(
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              color: commonbgblack,
                              border: Border.all(color: timePickerBorder, width: 1.0), // Change the color and width as needed
                              borderRadius: BorderRadius.circular(10), // Circular border radius
                            ),
                            child: attachments.isEmpty
                                ? Center(
                                    child: Text(
                                      "No attachments added",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                            :Padding(
                              padding: const EdgeInsets.all(8),
                              child: Scrollbar(
                                controller: scrollController,
                                thumbVisibility: true,
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1, // number of items in each row
                                    mainAxisSpacing: 15.0, // spacing between rows
                                    crossAxisSpacing: 8.0, // spacing between columns
                                    childAspectRatio: 35 / 9,
                                  ),
                                  itemCount: attachments.length,
                                  itemBuilder: (context, index) {
                                    return DownloadButton(
                                      key: ValueKey(attachments[index]),
                                      url: attachments[index],
                                      removeFile: () {
                                        deselectFile(index);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),

                          )
                          // : SizedBox(
                          //     height: 40,
                          //     child: selectedFiles != null &&
                          //             selectedFiles!.files.length > 0
                          //         ? ListView.builder(
                          //             scrollDirection: Axis.horizontal,
                          //             itemCount:
                          //                 selectedFiles?.files.length ?? 0,
                          //             itemBuilder: (context, index) {
                          //               var file = selectedFiles!.files[index];
                          //               return Container(
                          //                 width: 120,
                          //                 height: 10,
                          //                 padding: const EdgeInsets.symmetric(
                          //                     horizontal: 3.0),
                          //                 decoration: BoxDecoration(
                          //                   color: Colors.white,
                          //                   borderRadius:
                          //                       BorderRadius.circular(30.0),
                          //                 ),
                          //                 margin: const EdgeInsets.symmetric(
                          //                   horizontal: 6.0,
                          //                   vertical: 2.0,
                          //                 ),
                          //                 child: GestureDetector(
                          //                   onTap: () => openFile(file.path),
                          //                   child: Row(
                          //                     mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                     children: [
                          //                       Expanded(
                          //                         child: Text(
                          //                           file.name,
                          //                           style: TextStyle(
                          //                             fontSize: 10,
                          //                             color: Theme.of(context)
                          //                                 .colorScheme
                          //                                 .onBackground,
                          //                           ),
                          //                           overflow:
                          //                               TextOverflow.ellipsis,
                          //                         ),
                          //                       ),
                          //                       !user.isStudent
                          //                           ? GestureDetector(
                          //                               onTap: () =>
                          //                                   deselectFile(file),
                          //                               child: Icon(
                          //                                 Icons.cancel,
                          //                                 color:
                          //                                     Theme.of(context)
                          //                                         .colorScheme
                          //                                         .onBackground,
                          //                               ),
                          //                             )
                          //                           : Container(),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               );
                          //             },
                          //           )
                          //         : Center(
                          //             child: Text(
                          //               "No attachments added",
                          //               style: TextStyle(color: Colors.grey),
                          //             ),
                          //           ),
                          //   )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    // !user.isStudent
                    //     ? Row(
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: [
                    //           Padding(
                    //             padding:
                    //                 const EdgeInsets.fromLTRB(20, 11, 20, 11),
                    //             child: ElevatedButton(
                    //               style: ButtonStyle(
                    //                 backgroundColor:
                    //                     MaterialStateProperty.all<Color>(
                    //                         Theme.of(context)
                    //                             .colorScheme
                    //                             .onBackground),
                    //                 // You can customize other properties as needed
                    //                 // textColor, elevation, padding, shape, etc.
                    //               ),
                    //               onPressed: () async {
                    //                 await pickFiles();
                    //               },
                    //               child: Text('Attach',
                    //                   style: Theme.of(context)
                    //                       .textTheme
                    //                       .headlineMedium),
                    //             ),
                    //           ),
                    //         ],
                    //       )
                    //     : Container(),

                    const SizedBox(
                      height: 10,
                    ),
                    !user.isStudent
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: _size.width*0.9,),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(10, 11, 5, 11),
                                child: Container(
                                  width: _size.width*.5,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context)
                                              .colorScheme
                                              .onBackground),
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
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  width: _size.width*.5,
                                  child: ElevatedButton(

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
                                          newAttachments,
                                          deletedAttachments,
                                          attachments
                                              .where((file) =>
                                              file.startsWith("http"))
                                              .toList(),
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
                                ),
                              ),
                              widget.note != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        width: _size.width*.5,
                                        child: ElevatedButton(
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
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
