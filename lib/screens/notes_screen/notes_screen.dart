import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tsec_app/screens/notes_screen/widgets/note_list.dart';
import 'package:tsec_app/utils/image_assets.dart';
import 'package:tsec_app/utils/themes.dart';
import 'package:tsec_app/widgets/custom_app_bar.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // used for handeling blurr effect
  bool _isFilterVisible = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleFilterVisibility() {
    setState(() {
      _isFilterVisible = !_isFilterVisible;
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
    'DWM',
    'Stats',
    'WC',
    'ABC',
  ];

  final List _teachersName = [
    'Meenu Bhatia',
    'Meenu Bhatia',
    'Meenu Bhatia',
    'Meenu Bhatia',
    'Meenu Bhatia',
    'Meenu Bhatia',
  ];

  final List _date = [
    '26/11/23',
    '26/11/23',
    '26/11/23',
    '26/11/23',
    '26/11/23',
    '26/11/23',
  ];

  final List _noteTitle = [
    'Module 6 notes',
    'Module 6 notes',
    'Module 6 notes',
    'Module 6 notes',
    'Module 6 notes',
    'Module 6 notes',
  ];

  final List _noteContent = [
    "Dear students, I've attached the notes of the module which was taught today, refer if before coming for the next lecture.",
    "Dear students, I've attached the notes of the module which was taught today, refer if before coming for the next lecture.",
    "Dear students, I've attached the notes of the module which was taught today, refer if before coming for the next lecture.",
    "Dear students, I've attached the notes of the module which was taught today, refer if before coming for the next lecture.",
    "Dear students, I've attached the notes of the module which was taught today, refer if before coming for the next lecture.",
    "Dear students, I've attached the notes of the module which was taught today, refer if before coming for the next lecture.",
  ];

  final List _pdfCount = [
    '1',
    '2',
    '2',
    '3',
    '4',
    '3',
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    bool isItDarkMode = brightness == Brightness.dark;
    return CustomScaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(
            child: CustomAppBar(
              title: "Notes",
              image: Image.asset(ImageAssets.notes),
            ),
          )
        ],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 170,
                                        child: customFilterButton(
                                            0, "TSEC Official"),
                                      ),
                                      SizedBox(
                                        width: 170,
                                        child: customFilterButton(
                                            1, "TSEC Official"),
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
                                            child: customFilterButton(
                                                2, "TSEC Official"),
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
                                            child:
                                                customFilterButton(6, "Stats"),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                              borderRadius:
                                                  BorderRadius.circular(
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
                        height: 12,
                      ),
                      /*list from here, used listview builder to show the list 
                        for now, at the top are the lists used to show static 
                        data 
                      */

                      SizedBox(
                        /* try to adjust the height here,
                         temporalily wrote subject.lenght/2
                         subject = the list of the subject
                         the height is working as of now but if we
                         scroll too much, then there's lot of blank space 
                        */
                        height: MediaQuery.of(context).size.height *
                            _subjects.length /
                            2,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _subjects.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                // NoteList is in widgets folder
                                NoteList(
                                  subject: _subjects[index],
                                  noteTitle: _noteTitle[index],
                                  date: _date[index],
                                  noteContent: _noteContent[index],
                                  pdfCount: _pdfCount[index],
                                  teacherName: _teachersName[index],
                                ),
                                const SizedBox(
                                  height: 18,
                                )
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
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
