import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tsec_app/screens/notes_screen/widgets/custom_pdf_icon.dart';
import 'package:tsec_app/screens/notes_screen/widgets/note_list.dart';
import 'package:tsec_app/utils/image_assets.dart';
import 'package:tsec_app/utils/themes.dart';
import 'package:tsec_app/widgets/custom_app_bar.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

//  Line 309, Write Firebase uploading logic
// Line 649, firebase collection parameters (means this parameters are required,
// you can add extra if you want)

class _NotesScreenState extends State<NotesScreen> {
  // used for handeling blurr effect
  bool _isFilterVisible = false;
  final TextEditingController _searchController = TextEditingController();

  FilePickerResult? selectedFiles;
  bool _dialogVisible = false;

  void _toggleFilterVisibility() {
    setState(() {
      _isFilterVisible = !_isFilterVisible;
    });
  }

  void _toggleFilterVisibility2() {
    setState(() {
      _dialogVisible = !_dialogVisible;
    });
  }

  List<bool> isSelected = List.generate(9, (index) => false);

  Future<void> _pickFiles() async {
    FilePickerResult? results = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: true,
    );

    if (results != null) {
      setState(() {
        selectedFiles = results;
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
    if (filePath != null) {
      OpenFile.open(filePath);
    }
  }

  void _onButtonPressed(int index) {
    setState(() {
      // Update the list to mark the selected button
      isSelected[index] = isSelected[index] ? false : true;
    });
  }

  /* this is the static data for the post as for now
  */
  final List _subjects = [
    'AI',
    'CN',
  ];

  final List _teachersName = [
    'Meenu Bhatia',
    'Meenu Bhatia',
  ];

  final List _date = [
    '26/11/23',
    '26/11/23',
  ];

  final List _noteTitle = [
    'Module 6 notes',
    'Module 6 notes',
  ];

  final List _noteContent = [
    "Dear students, I've attached the notes of the module which was taught today, refer if before coming for the next lecture.",
    "Dear students, I've attached the notes of the module which was taught today, refer if before coming for the next lecture.",
  ];

  final List _pdfCount = [
    '1',
    '2',
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    bool isItDarkMode = brightness == Brightness.dark;
    return Scaffold(
      floatingActionButton: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: _dialogVisible ? 10.0 : 0.0,
          sigmaY: _dialogVisible ? 10.0 : 0.0,
        ),
        child: AnimatedCrossFade(
          duration: const Duration(
            milliseconds: 100,
          ),
          firstChild: FloatingActionButton(
            onPressed: _toggleFilterVisibility2,
            tooltip: 'Add Notes',
            child: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
          ),
          secondChild: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.secondary,
            ),
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Subject",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(left: 14),
                  child: const TextField(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Title",
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  padding: const EdgeInsets.all(8.0).copyWith(left: 14),
                  child: const TextField(
                    maxLines: 7,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Description",
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(left: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Attachments',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount: selectedFiles?.files.length ?? 0,
                          itemBuilder: (context, index) {
                            var file = selectedFiles!.files[index];
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 2.0),
                              child: GestureDetector(
                                onTap: () => openFile(file.path),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        file.name ?? '',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.blue,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => deselectFile(file),
                                      child: const Icon(
                                        Icons.cancel,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     CustomPdfIcon(
                      //       pdfName: "module_5.pdf",
                      //     ),
                      //     SizedBox(
                      //       width: 8,
                      //     ),
                      //     CustomPdfIcon(
                      //       pdfName: "module_6.pdf",
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 40,
                        left: 30,
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _pickFiles();
                          },
                          child: const Text('Attach'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _dialogVisible = false;
                          });
                        },
                        icon: Icon(
                          Icons.cancel_outlined,
                          color:
                              // Theme.of(context).colorScheme.onSecondaryContainer,
                              Colors.green.shade400,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Firebase uploading logic
                    },
                    child: const Text('Upload'),
                  ),
                ),
              ],
            ),
          ),
          crossFadeState: !_dialogVisible
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 235,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildNavigation(
                            context,
                            icon: const Icon(Icons.chevron_left_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Notes",
                              style: Theme.of(context).textTheme.headline3,
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
              const SizedBox(
                height: 10,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _isFilterVisible ? 10.0 : 0.0,
                  sigmaY: _isFilterVisible ? 10.0 : 0.0,
                ),
                child: AnimatedCrossFade(
                  duration: const Duration(seconds: 1),

                  // First Child is the search bar
                  firstChild: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: isItDarkMode
                          ? shadowLightModeTextFields
                          : shadowDarkModeTextFields,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.blue,
                        ),
                        suffixIcon: IconButton(
                          onPressed: _toggleFilterVisibility,
                          icon: const Icon(
                            Icons.tune,
                            color: Colors.blue,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: (Theme.of(context).primaryColor ==
                                    const Color(0xFFF2F5F8))
                                ? Colors.black54
                                : Colors.white38,
                            width: 1.0,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        filled: true,
                        hintStyle: TextStyle(
                          color: (Theme.of(context).primaryColor ==
                                  const Color(0xFFF2F5F8))
                              ? Colors.grey[500]
                              : Colors.white60,
                        ),
                        hintText: "Search",
                        fillColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),

                  // Second child is the filter bar
                  secondChild: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: isItDarkMode
                          ? shadowLightModeTextFields
                          : shadowDarkModeTextFields,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 160,
                                child: TextButton(
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2025),
                                    );
                                  },
                                  child: const Text("Start date"),
                                ),
                              ),
                              const SizedBox(
                                width: 40,
                                child: Icon(
                                  Icons.arrow_right_alt_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 160,
                                child: TextButton(
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2025),
                                    );
                                  },
                                  child: const Text("End date"),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 170,
                                child: customFilterButton(0, "TSEC Official"),
                              ),
                              SizedBox(
                                width: 170,
                                child: customFilterButton(1, "TSEC Official"),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          Column(
                            children: [
                              const Text("Subjects"),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 170,
                                    child:
                                        customFilterButton(2, "TSEC Official"),
                                  ),
                                  SizedBox(
                                    width: 170,
                                    child: customFilterButton(2, "DWM"),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 170,
                                    child: customFilterButton(4, "CN"),
                                  ),
                                  SizedBox(
                                    width: 170,
                                    child: customFilterButton(4, "WCN"),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 170,
                                    child: customFilterButton(6, "Stats"),
                                  ),
                                  SizedBox(
                                    width: 170,
                                    child: customFilterButton(7, "AI"),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 170,
                                    child: customFilterButton(
                                      8,
                                      "MPR",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    /* wirte the filter logic code 
                                            (like which note will be shown on a 
                                            particular filter)
                                            */
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        50.0,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Apply Filter",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              // cross button (i.e to close the filter)
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isFilterVisible = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  crossFadeState: !_isFilterVisible
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  // NoteList is in widgets folder
                  NoteList(
                    subject: _subjects[0],
                    noteTitle: _noteTitle[0],
                    date: _date[0],
                    noteContent: _noteContent[0],
                    pdfCount: _pdfCount[0],
                    teacherName: _teachersName[0],
                  ),
                  const SizedBox(
                    height: 18,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconTheme(
          data: const IconThemeData(color: kLightModeLightBlue),
          child: icon,
        ),
      ),
    );
  }

  Widget customFilterButton(int index, String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () {
          _onButtonPressed(index);
        },
        child: Text(buttonText),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              // Change color based on the selection
              if (isSelected[index]) {
                return Colors.blue; // Selected color
              }
              return Colors.grey; // Default color
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              // Change text color based on the selection
              if (isSelected[index]) {
                return Colors.white; // Selected text color
              }
              return Colors.black; // Default text color
            },
          ),
        ),
      ),
    );
  }
}
