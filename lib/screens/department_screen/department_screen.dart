import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tsec_app/screens/department_screen/widgets/about_section.dart';
import 'package:tsec_app/utils/themes.dart';

import 'widgets/department_screen_app_bar.dart';
import 'widgets/drop_down_menu_item.dart';

class DepartmentScreen extends StatefulWidget {
  String departmentName;

  String selectedItem;

  DepartmentScreen(
      {Key? key, required this.departmentName, this.selectedItem = "About"})
      : super(key: key);

  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
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
            color: Theme.of(context).accentColor,
            border: Border.all(color: kLightModeLightBlue),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            children: [
              DropDownMenuItem(
                  title: "About",
                  onTap: () {
                    setState(() {
                      widget.selectedItem = "About";
                    });
                    overlayEntry!.remove();
                  }),
              DropDownMenuItem(
                  title: "Faculty Details",
                  onTap: () {
                    setState(() {
                      widget.selectedItem = "Faculty Details";
                    });
                    overlayEntry!.remove();
                  }),
              DropDownMenuItem(
                  title: "Placement Details",
                  onTap: () {
                    setState(() {
                      widget.selectedItem = "Placement Details";
                    });
                    overlayEntry!.remove();
                  }),
              DropDownMenuItem(
                  title: "Result Analysis",
                  onTap: () {
                    setState(() {
                      widget.selectedItem = "Result Analysis";
                    });
                    overlayEntry!.remove();
                  }),
              DropDownMenuItem(
                  title: "Curriculum",
                  onTap: () {
                    setState(() {
                      widget.selectedItem = "Curriculum";
                    });
                    overlayEntry!.remove();
                  }),
              DropDownMenuItem(
                  title: "More",
                  onTap: () {
                    setState(() {
                      widget.selectedItem = "More";
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
                color: Theme.of(context).accentColor,
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
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                        const Spacer(),
                        VerticalDivider(
                          color: Theme.of(context).primaryColorLight,
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
                            child: Icon(
                              Icons.chevron_left,
                              size: 30,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            AboutSection(),
          ],
        ),
      ),
    );
  }
}
