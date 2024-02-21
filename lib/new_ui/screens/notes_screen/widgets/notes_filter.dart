import 'package:flutter/material.dart';

class NotesFilterBar extends StatefulWidget {
  const NotesFilterBar({super.key});

  @override
  State<NotesFilterBar> createState() => _NotesFilterBarState();
}

class _NotesFilterBarState extends State<NotesFilterBar> {
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

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
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
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
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
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor:
                            Theme.of(context).colorScheme.onBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                        ),
                      ),
                      child: Text(
                        "Apply Filters",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
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
    );
  }
}
