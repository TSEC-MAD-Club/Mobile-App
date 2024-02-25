// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsec_app/models/about_department_model/about_department_model.dart';

import '../../../utils/themes.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({Key? key, required this.department}) : super(key: key);
  final String department;
  @override
  _AboutSectionState createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  late final Future<List<String>> _aboutDepartment;

  Future<List<String>> _getAboutDepartment() async {
    final data = await rootBundle.loadString("assets/data/about_department/about.json");
    final json = jsonDecode(data) as List;
    Map<String, List<String>> deptAboutMap = {
      for (var item in json)
        AboutDepartmentModel.fromJson(item).department: [
          AboutDepartmentModel.fromJson(item).aboutDepartment,
          AboutDepartmentModel.fromJson(item).vision,
          AboutDepartmentModel.fromJson(item).mission
        ]
    };
    return deptAboutMap[widget.department]!;
  }

  @override
  void initState() {
    super.initState();
    _aboutDepartment = _getAboutDepartment();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _aboutDepartment,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var aboutList = snapshot.data as List<String>;
          var about = aboutList[0];
          var vision = aboutList[1];
          var mission = aboutList[2] != "na" ? aboutList[2].split('|') : [];
          return Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: SizedBox(
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outline,
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Center(
                          child: ExpandablePanel(
                            theme: ExpandableThemeData(iconColor: Theme.of(context).colorScheme.onSecondary),
                            header: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "About",
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                            collapsed: Text(about,
                                softWrap: true,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12)),
                            expanded: Text(
                              about,
                              softWrap: true,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                      ),
                      if (vision != "na") ...[
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.outline,
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Center(
                            child: ExpandablePanel(
                              theme: ExpandableThemeData(iconColor: Theme.of(context).colorScheme.onSecondary),
                              header: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Vision",
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                              ),
                              collapsed: Text(
                                vision,
                                softWrap: true,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12),
                              ),
                              expanded: Text(
                                vision,
                                softWrap: true,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (mission.isNotEmpty) ...[
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.outline,
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Center(
                            child: ExpandablePanel(
                              theme: ExpandableThemeData(iconColor: Theme.of(context).colorScheme.onSecondary),
                              header: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Mission",
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                              ),
                              collapsed: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: true,
                                text: TextSpan(
                                  text: "",
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12),
                                  children: [
                                    if (true)
                                      for (var i = 1; i <= 2; i++)
                                        i % 2 == 0
                                            ? TextSpan(
                                                text: " " + mission[i ~/ 2 - 1] + "\n",
                                              )
                                            : WidgetSpan(
                                                child: Icon(
                                                  Icons.check_box_outlined,
                                                  size: 20,
                                                  color: Theme.of(context).colorScheme.onSecondary,
                                                ),
                                              ),
                                  ],
                                ),
                              ),
                              expanded: RichText(
                                text: TextSpan(
                                  text: "",
                                  style: Theme.of(context).textTheme.titleSmall,
                                  children: [
                                    for (var i = 1; i <= mission.length * 2; i++)
                                      i % 2 == 0
                                          ? TextSpan(text: " " + mission[i ~/ 2 - 1] + "\n")
                                          : WidgetSpan(
                                              child: Icon(
                                                Icons.check_box_outlined,
                                                size: 20,
                                                color: Theme.of(context).colorScheme.onSecondary,
                                              ),
                                            ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
