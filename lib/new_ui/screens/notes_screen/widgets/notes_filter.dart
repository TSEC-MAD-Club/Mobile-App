import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tsec_app/models/subject_model/subject_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/subjects_provider.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
import 'package:tsec_app/utils/profile_details.dart';

class NotesFilterBar extends ConsumerStatefulWidget {
  DateTime? startDate;
  String searchQuery;
  DateTime? endDate;
  void Function(String newQuery) modifySearchQuery;
  bool latest;
  List<String> subjects;
  Function(DateTime?, DateTime?, bool, List<String>) changeFilters;
  Function clearAllFilters;
  NotesFilterBar({
    super.key,
    required this.searchQuery,
    required this.modifySearchQuery,
    required this.startDate,
    required this.endDate,
    required this.latest,
    required this.subjects,
    required this.changeFilters,
    required this.clearAllFilters,
  });

  @override
  ConsumerState<NotesFilterBar> createState() => _NotesFilterBarState();
}

class _NotesFilterBarState extends ConsumerState<NotesFilterBar>
    with SingleTickerProviderStateMixin {
  // final TextEditingController _searchController = TextEditingController();

  Widget customFilterButton(String text, bool activeButton, Function onTap) {
    return Container(
      child: TextButton(
        onPressed: () {
          onTap();
        },
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: activeButton ? Colors.white : Colors.black),
        ),
        style: ButtonStyle(
          // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //   RoundedRectangleBorder(
          //     borderRadius:
          //         BorderRadius.circular(10.0), // Set the border radius
          //   ),
          // ),
          // maximumSize: MaterialStateProperty.all(
          //   Size(150.0, 50.0),
          // ), // Set the minimum size
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              // Change color based on the selection
              if (activeButton) {
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

  late AnimationController _animationController;
  late Animation sizeAnimation;
  // late DateTime? startDate;
  // late DateTime? endDate;
  // late bool latest;
  // List<String> selectedSubjects = [];

  // void setLocalState() {
  //   startDate = widget.startDate;
  //   endDate = widget.endDate;
  //   latest = widget.latest;
  //   selectedSubjects = widget.subjects;
  // }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    UserModel? user = ref.read(userModelProvider);
    sizeAnimation = Tween<double>(begin: 60, end: user!.isStudent ? 500 : 200)
        .animate(_animationController);
    // setLocalState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _isFilterVisible = false;
  void _toggleFilterVisibility() {
    if (_isFilterVisible) {
      _animationController.reverse();
      setState(() {
        _isFilterVisible = false;
      });
    } else {
      _animationController.forward();
      setState(() {
        _isFilterVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = ref.watch(userModelProvider)!;
    SubjectModel subjects = ref.read(subjectsProvider);

    SemesterData semData = subjects.dataMap[
            "${calcGradYear(user.studentModel?.gradyear)}_${user.studentModel?.branch}"] ??
        SemesterData(even_sem: [], odd_sem: []);
        debugPrint(semData.even_sem.toString());
    List<String> allSubjects =
        evenOrOddSem() == "even_sem" ? semData.even_sem : semData.odd_sem;
    // debugPrint(allSubjects.toString());
    // debugPrint(
    //     "${user!.studentModel?.gradyear} ${user.studentModel?.branch} ${evenOrOddSem()}");
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SliverAppBar(
          pinned: true,
          // toolbarHeight: _isFilterVisible ? 500 : 60,
          toolbarHeight: sizeAnimation.value,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: AnimatedCrossFade(
            duration: const Duration(milliseconds: 500),
            // First Child is the search bar
            firstChild: SizedBox(
              height: 50,
              child: TextField(
                // controller: _searchController,
                onChanged: widget.modifySearchQuery,
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
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  filled: true,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  hintText: "Search",
                  fillColor: Theme.of(context).colorScheme.onSecondary,
                  contentPadding: const EdgeInsets.fromLTRB(48, 12, 12, 12), // Adjust padding if needed
                ),
                textAlign: TextAlign.start,
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
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: TextButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: widget.startDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2025),
                              );
                              if (pickedDate != null) {
                                // setState(() {~
                                //   startDate = pickedDate;
                                // });
                                widget.changeFilters(pickedDate, widget.endDate,
                                    widget.latest, widget.subjects);
                              } else {
                                // print(
                                //     "Date is not selected");
                              }
                            },
                            child: Text(
                              widget.startDate != null
                                  ? DateFormat('d MMM y')
                                      .format(widget.startDate!)
                                  : "Start date",
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
                          width: 20,
                          child: Icon(
                            Icons.arrow_right_alt_rounded,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: TextButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: widget.endDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2025),
                              );
                              if (pickedDate != null) {
                                if (widget.startDate != null &&
                                    pickedDate.isBefore(widget.startDate!)) {
                                  showSnackBar(context,
                                      "Please select an appropriate date");
                                  return;
                                }
                                // setState(() {
                                //   endDate = pickedDate;
                                // });

                                widget.changeFilters(widget.startDate,
                                    pickedDate, widget.latest, widget.subjects);
                              } else {
                                // print(
                                //     "Date is not selected");
                              }
                            },
                            child: Text(
                              widget.endDate != null
                                  ? DateFormat('d MMM y')
                                      .format(widget.endDate!)
                                  : "End date",
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
                          width: MediaQuery.of(context).size.width * 0.40,
                          child:
                              customFilterButton("Latest", widget.latest, () {
                            widget.changeFilters(
                                widget.startDate,
                                widget.endDate,
                                !widget.latest,
                                widget.subjects);
                          }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child:
                              customFilterButton("Oldest", !widget.latest, () {
                            widget.changeFilters(
                                widget.startDate,
                                widget.endDate,
                                !widget.latest,
                                widget.subjects);
                          }),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    user.isStudent && allSubjects.isNotEmpty
                        ? Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Text("Subjects"),
                              SizedBox(
                                height: 250,
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        2, // number of items in each row
                                    mainAxisSpacing:
                                        15.0, // spacing between rows
                                    crossAxisSpacing:
                                        8.0, // spacing between columns
                                    childAspectRatio: 30 / 9,
                                  ),
                                  padding: const EdgeInsets.all(
                                      8.0), // padding around the grid
                                  itemCount: allSubjects
                                      .length, // total number of items
                                  itemBuilder: (context, index) {
                                    return customFilterButton(
                                      allSubjects[index],
                                      widget.subjects
                                          .contains(allSubjects[index]),
                                      () {
                                        List<String> tempSubjects =
                                            widget.subjects;
                                        if (tempSubjects
                                            .contains(allSubjects[index])) {
                                          tempSubjects = tempSubjects
                                              .where((el) =>
                                                  el != allSubjects[index])
                                              .toList();
                                        } else {
                                          tempSubjects.add(allSubjects[index]);
                                        }
                                        debugPrint(
                                            "after change: all subjects ${allSubjects.length}");
                                        debugPrint(
                                            "after change: widget subjects ${widget.subjects.length}");
                                        widget.changeFilters(
                                            widget.startDate,
                                            widget.endDate,
                                            widget.latest,
                                            tempSubjects);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(
                      height: 15,
                    ),
                    // Row(
                    //   children: [
                    //     const Spacer(),
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         widget.changeFilters(
                    //             startDate, endDate, latest, selectedSubjects);
                    //         _toggleFilterVisibility();
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         // padding:
                    //         //     const EdgeInsets.symmetric(vertical: 10),
                    //         backgroundColor:
                    //             Theme.of(context).colorScheme.onBackground,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(
                    //             20.0,
                    //           ),
                    //         ),
                    //       ),
                    //       child: Text(
                    //         "Apply Filters",
                    //         style: TextStyle(
                    //           color: Theme.of(context).colorScheme.onSecondary,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Align(
                    //         alignment: Alignment.centerRight,
                    //         child: IconButton(
                    //           onPressed: () {
                    //             _toggleFilterVisibility();
                    //           },
                    //           icon: Icon(
                    //             Icons.cancel_outlined,
                    //             color: Theme.of(context)
                    //                 .colorScheme
                    //                 .onSecondaryContainer,
                    //             size: 30,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            _toggleFilterVisibility();
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            widget.clearAllFilters();
                            // _toggleFilterVisibility();
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            size: 30,
                          ),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     widget.clearAllFilters();
                        //     // setLocalState();
                        //     _toggleFilterVisibility();
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     // padding:
                        //     //     const EdgeInsets.symmetric(vertical: 10),
                        //     backgroundColor:
                        //         Theme.of(context).colorScheme.error,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(
                        //         20.0,
                        //       ),
                        //     ),
                        //   ),
                        //   child: Text(
                        //     "Reset Filters",
                        //     style: Theme.of(context).textTheme.titleMedium,
                        //   ),
                        // ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     widget.changeFilters(
                        //       startDate,
                        //       endDate,
                        //       latest,
                        //       selectedSubjects,
                        //     );
                        //     _toggleFilterVisibility();
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     // padding:
                        //     //     const EdgeInsets.symmetric(vertical: 10),
                        //     backgroundColor:
                        //         Theme.of(context).colorScheme.onBackground,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(
                        //         20.0,
                        //       ),
                        //     ),
                        //   ),
                        //   child: Text(
                        //     "Apply Filters",
                        //     style: Theme.of(context).textTheme.titleMedium,
                        //   ),
                        // ),
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
        );
      },
    );
  }
}
