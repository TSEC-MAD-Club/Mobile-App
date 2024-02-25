// ignore_for_file: lines_longer_than_80_chars

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tsec_app/screens/department_screen/widgets/curriculum_section.dart';
import 'package:tsec_app/utils/department_enum.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_scaffold.dart';
import 'widgets/about_section.dart';
import 'widgets/department_screen_app_bar.dart';
import 'widgets/drop_down_menu_item.dart';
import 'widgets/faculty_details_section.dart';

enum Item {
  about,
  facultyDetails,
  curriculum,
}

extension ItemNameExtension on Item {
  String get name {
    switch (this) {
      case Item.about:
        return "About";
      case Item.facultyDetails:
        return "Faculty Details";
      case Item.curriculum:
        return "Curriculum";
    }
  }
}

OverlayEntry? overlayEntry;

class DepartmentScreen extends StatefulWidget {
  final DepartmentEnum department;

  const DepartmentScreen({
    Key? key,
    required this.department,
  }) : super(key: key);

  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  Item selectedItem = Item.about;

  final GlobalKey _dropDownKey = GlobalKey();

  void _showDropDown(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);

    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        left: 20,
        top: _getDropdownVerticalPosition(),
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
              for (var item in Item.values)
                DropDownMenuItem(
                    title: item.name,
                    onTap: () {
                      setState(() {
                        selectedItem = item;
                      });
                      overlayEntry?.remove();
                      overlayEntry = null;
                    }),
            ],
          ),
        ),
      );
    });
    overlayState.insert(overlayEntry!);
  }

  Widget section(Item item) {
    switch (item) {
      case Item.about:
        return AboutSection(department: widget.department.name);
      case Item.facultyDetails:
        return FacultyDetailsSection(department: widget.department);
      case Item.curriculum:
        return CurriculumSection(department: widget.department);
    }
  }

  double _getDropdownVerticalPosition() {
    final RenderBox rowRenderBox = _dropDownKey.currentContext?.findRenderObject() as RenderBox;
    final rowHeight = rowRenderBox.size.height;
    final rowOffsetTop = rowRenderBox.localToGlobal(Offset.zero).dy;
    return rowHeight + rowOffsetTop + 10;
  }

  @override
  void dispose() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
    }

    overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> list = ["About", "Faculty", "Curriculum"];
    int selected = 0;
    List<Widget> screen = [
      AboutSection(department: widget.department.name),
      FacultyDetailsSection(department: widget.department),
      CurriculumSection(department: widget.department)
    ];

    return WillPopScope(
      onWillPop: () async {
        if (overlayEntry != null) {
          overlayEntry?.remove();
          overlayEntry = null;
          return false;
        }
        return true;
      },
      child: Scaffold(
        // appBar: const DepartmentScreenAppBar(title: "Department"),
        body: SafeArea(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Department",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.department.name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.08,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: size.width,
                          height: size.height * 0.4,
                          child: Align(
                            alignment: Alignment.center,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selected = index;
                                      selectedItem = Item.values[index];
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AnimatedContainer(
                                      alignment: Alignment.center,
                                      width: 90,
                                      height: 100,
                                      duration: const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: selectedItem.index == index ? Theme.of(context).colorScheme.primary : null,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          list[index],
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: selectedItem.index == index
                                                    ? Theme.of(context).colorScheme.onPrimary
                                                    : Theme.of(context).colorScheme.onSecondary,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        section(selectedItem),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          //section(selectedItem),
        ),
      ),
    );
  }
}
