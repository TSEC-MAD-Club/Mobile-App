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
    final RenderBox rowRenderBox =
        _dropDownKey.currentContext?.findRenderObject() as RenderBox;
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

    return WillPopScope(
      onWillPop: () async {
        if (overlayEntry != null) {
          overlayEntry?.remove();
          overlayEntry = null;
          return false;
        }
        return true;
      },
      child: CustomScaffold(
        appBar: const DepartmentScreenAppBar(title: "Department"),
        body: SizedBox(
          width: size.width,
          child: Column(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius:
                      const BorderRadius.only(bottomRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.department.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontSize: 22),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      width: 230,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: kLightModeLightBlue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        key: _dropDownKey,
                        children: [
                          Text(
                            selectedItem.name,
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
                              if (overlayEntry == null) {
                                _showDropDown(context);
                              } else {
                                overlayEntry?.remove();
                                overlayEntry = null;
                              }
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
      ),
    );
  }
}
