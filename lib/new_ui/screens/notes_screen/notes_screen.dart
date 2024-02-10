import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/custom_pdf_icon.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/note_list.dart';
import 'package:tsec_app/new_ui/screens/notes_screen/widgets/notes_modal.dart';
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

  bool _dialogVisible = false;

  void _toggleFilterVisibility() {
    setState(() {
      _isFilterVisible = !_isFilterVisible;
    });
  }

  void _toggleDialogVisibility() {
    setState(() {
      _dialogVisible = !_dialogVisible;
    });
  }

  List<bool> isSelected = List.generate(9, (index) => false);


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
    // final brightness = Theme.of(context).brightness;
    // bool isItDarkMode = brightness == Brightness.dark;
    return Scaffold(
      floatingActionButton: OpenContainer(
      transitionDuration: Duration(milliseconds: 500),
        closedColor: Theme.of(context).colorScheme.background,
        closedBuilder: (context, action) {
          return FloatingActionButton(
            // backgroundColor: Colors.transparent,
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
          return NotesModal(action: action);
        },
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 235,
                // decoration: BoxDecoration(
                //   // color: Theme.of(context).colorScheme.secondary,
                //   borderRadius: const BorderRadius.only(
                //     bottomRight: Radius.circular(40),
                //   ),
                // ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 500),
                // First Child is the search bar
                firstChild: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    // boxShadow: isItDarkMode
                    //     ? shadowLightModeTextFields
                    //     : shadowDarkModeTextFields,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                        onPressed: _toggleFilterVisibility,
                        icon: const Icon(
                          Icons.tune,
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        // borderSide: BorderSide(
                        //   color: (Theme.of(context).primaryColor ==
                        //           const Color(0xFFF2F5F8))
                        //       ? Colors.black54
                        //       : Colors.white38,
                        //   width: 1.0,
                        // ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: "Search",
                      fillColor: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
                // Second child is the filter bar
                secondChild: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Theme.of(context).colorScheme.tertiary,
                    // boxShadow: isItDarkMode
                    //     ? shadowLightModeTextFields
                    //     : shadowDarkModeTextFields,
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
                                child: Text(
                                  "Start date",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.black,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                              child: Icon(
                                Icons.arrow_right_alt_rounded,
                                color: Colors.black,
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
                                child: Text(
                                  "End date",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.black,
                                      ),
                                ),
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
                              child: customFilterButton(0, "Latest"),
                            ),
                            SizedBox(
                              width: 170,
                              child: customFilterButton(1, "Oldest"),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 170,
                                  child: customFilterButton(2, "TSEC Official"),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          children: [
                            const Spacer(),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      20.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Apply Filters",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
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
                        ),
                      ],
                    ),
                  ),
                ),
                crossFadeState: !_isFilterVisible
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
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

  Widget customFilterButton(int index, String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () {
          _onButtonPressed(index);
        },
        child: Text(buttonText,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: isSelected[index] ? Colors.white : Colors.black)),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              // Change color based on the selection
              if (isSelected[index]) {
                return Theme.of(context)
                    .colorScheme
                    .primaryContainer; // Selected color
              }
              return Colors.white; // Default color
            },
          ),
        ),
      ),
    );
  }
}
