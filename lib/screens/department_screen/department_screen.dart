import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tsec_app/screens/department_screen/widgets/about_section.dart';
import 'package:tsec_app/screens/department_screen/widgets/faculty_details_section.dart';
import 'package:tsec_app/utils/themes.dart';

import 'department_constants.dart';
import 'widgets/department_screen_app_bar.dart';
import 'widgets/drop_down_menu_item.dart';

class DepartmentScreen extends StatefulWidget {
  final String departmentName;

  final String selectedItem;

  const DepartmentScreen(
      {Key? key,
      required this.departmentName,
      this.selectedItem = ABOUT_SECTION})
      : super(key: key);

  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  late String selectedItem;
  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
  }

  void _showDropDown(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    OverlayState overlayState = Overlay.of(context)!;
    late OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        left: 20,
        top: size.height * 0.27,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: 230,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            border: Border.all(color: kLightModeLightBlue),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            children: [
              DropDownMenuItem(
                  title: "About",
                  onTap: () {
                    setState(() {
                      selectedItem = ABOUT_SECTION;
                    });
                    overlayEntry!.remove();
                  }),
              DropDownMenuItem(
                  title: "Faculty Details",
                  onTap: () {
                    setState(() {
                      selectedItem = FACULTY_DETAILS_SECTION;
                    });
                    overlayEntry!.remove();
                  }),
              DropDownMenuItem(
                  title: "Placement Details",
                  onTap: () {
                    setState(() {
                      selectedItem = PLACEMENT_DETAILS_SECTION;
                    });
                    overlayEntry!.remove();
                  }),
              DropDownMenuItem(
                  title: "Result Analysis",
                  onTap: () {
                    setState(() {
                      selectedItem = RESULT_ANALYSIS_SECTION;
                    });
                    overlayEntry!.remove();
                  }),
              DropDownMenuItem(
                  title: "Curriculum",
                  onTap: () {
                    setState(() {
                      selectedItem = CURRICULUM_SECTION;
                    });
                    overlayEntry!.remove();
                  }),
              DropDownMenuItem(
                  title: "More",
                  onTap: () {
                    setState(() {
                      selectedItem = MORE_SECTION;
                    });
                    overlayEntry!.remove();
                  }),
            ],
          ),
        ),
      );
    });
    overlayState.insert(overlayEntry);
  }

  Widget section(String sectionName) {
    switch (sectionName) {
      case ABOUT_SECTION:
        return const AboutSection();
      case FACULTY_DETAILS_SECTION:
        return const FacultyDetailsSection();
      default:
        return const AboutSection();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const DepartmentScreenAppBar(
        title: "Department",
      ),
      body: SizedBox(
        width: size.width,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width,
              height: 0.18 * size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.departmentName,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontSize: 22),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    width: 230,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: kLightModeLightBlue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          widget.selectedItem,
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: Colors.white),
                        ),
                        const Spacer(),
                        const VerticalDivider(
                          color: Colors.white,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            _showDropDown(context);
                          },
                          child: Transform.rotate(
                            angle: -90 * pi / 180,
                            child: const Icon(
                              Icons.chevron_left,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            section(selectedItem),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kLightModeLightBlue,
        child: Image.asset('assets/images/department/slide_drawer.png'),
      ),
    );
  }
}
