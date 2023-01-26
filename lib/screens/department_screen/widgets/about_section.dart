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
    final data =
        await rootBundle.loadString("assets/data/about_department/about.json");
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About Department",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontSize: 20, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.only(
                            left: 15, right: 10, top: 0, bottom: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 3),
                              blurRadius: 7,
                              color: kLightModeLightBlue.withOpacity(0.23),
                            ),
                          ],
                        ),
                        child: Center(
                          child: ExpandablePanel(
                            theme: const ExpandableThemeData(
                                iconColor: kLightModeLightBlue),
                            header: const Text(""),
                            collapsed: Text(
                              about,
                              softWrap: true,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            expanded: Text(
                              about,
                              softWrap: true,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                      if (vision != "na") ...[
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Vision",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.only(
                              left: 15, right: 10, top: 0, bottom: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 3),
                                blurRadius: 7,
                                color: kLightModeLightBlue.withOpacity(0.23),
                              ),
                            ],
                          ),
                          child: Center(
                            child: ExpandablePanel(
                              theme: const ExpandableThemeData(
                                  iconColor: kLightModeLightBlue),
                              header: const Text(""),
                              collapsed: Text(
                                vision,
                                softWrap: true,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              expanded: Text(
                                vision,
                                softWrap: true,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (mission.isNotEmpty) ...[
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Mission",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.only(
                              left: 15, right: 10, top: 0, bottom: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 3),
                                blurRadius: 7,
                                color: kLightModeLightBlue.withOpacity(0.23),
                              ),
                            ],
                          ),
                          child: Center(
                            child: ExpandablePanel(
                              theme: const ExpandableThemeData(
                                  iconColor: kLightModeLightBlue),
                              header: const Text(""),
                              collapsed: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,
                                text: TextSpan(
                                  text: "",
                                  style: Theme.of(context).textTheme.bodySmall,
                                  children: [
                                    if (true)
                                      for (var i = 1; i <= 2; i++)
                                        i % 2 == 0
                                            ? TextSpan(
                                                text: " " +
                                                    mission[i ~/ 2 - 1] +
                                                    "\n",
                                              )
                                            : const WidgetSpan(
                                                child: Icon(
                                                  Icons.check_box_outlined,
                                                  size: 20,
                                                  color: kLightModeLightBlue,
                                                ),
                                              ),
                                  ],
                                ),
                              ),
                              expanded: RichText(
                                text: TextSpan(
                                  text: "",
                                  style: Theme.of(context).textTheme.bodySmall,
                                  children: [
                                    for (var i = 1;
                                        i <= mission.length * 2;
                                        i++)
                                      i % 2 == 0
                                          ? TextSpan(
                                              text: " " +
                                                  mission[i ~/ 2 - 1] +
                                                  "\n")
                                          : const WidgetSpan(
                                              child: Icon(
                                                Icons.check_box_outlined,
                                                size: 20,
                                                color: kLightModeLightBlue,
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
