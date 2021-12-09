import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/models/department_model/about_model.dart';

import 'package:tsec_app/utils/themes.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  _AboutSectionState createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  @override
  Widget build(BuildContext context) {
    AboutModel aboutModel = AboutModel();
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SizedBox(
            width: size.width,
            height: null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About Department",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w500),
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
                    color: Theme.of(context).accentColor,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                      header: const Text(""),
                      collapsed: Text(
                        aboutModel.aboutDepartment,
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      expanded: Text(
                        aboutModel.aboutDepartment,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Vision",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w500),
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
                    color: Theme.of(context).accentColor,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                      header: const Text(""),
                      collapsed: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                        text: TextSpan(
                          text: "",
                          style: Theme.of(context).textTheme.bodyText2,
                          children: [
                            if(true)
                            for (var i = 1;i <= 2;i++)
                              i % 2 == 0? TextSpan(text: " " +aboutModel.visionList[i ~/ 2 - 1] +"\n",)
                                  : const WidgetSpan(child: Icon(Icons.check_box_outlined,size: 20,
                                        color: kLightModeLightBlue,
                                        ),
                                    )
                          ],
                        ),
                      ),
                      expanded: RichText(
                        text: TextSpan(
                          text: "",
                          style: Theme.of(context).textTheme.bodyText2,
                          children: [
                            for (var i = 1;i <= aboutModel.visionList.length * 2;i++)
                              i % 2 == 0? TextSpan(text: " " +aboutModel.visionList[i ~/ 2 - 1] +"\n")
                                  : const WidgetSpan(child: Icon(Icons.check_box_outlined,
                                      size: 20,
                                      color: kLightModeLightBlue,
                                    ),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Mission",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w500),
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
                    color: Theme.of(context).accentColor,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                      header: const Text(""),
                      collapsed: Text(
                        aboutModel.mission,
                        softWrap: true,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      expanded: Text(
                        aboutModel.mission,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
