import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/faculty_model/faculty_model.dart';
import '../../../utils/department_enum.dart';
import '../../../utils/themes.dart';

class FacultyDetailsSection extends StatefulWidget {
  const FacultyDetailsSection({
    Key? key,
    required this.department,
  }) : super(key: key);
  final DepartmentEnum department;
  @override
  _FacultyDetailsSectionState createState() => _FacultyDetailsSectionState();
}

class _FacultyDetailsSectionState extends State<FacultyDetailsSection> {
  late final Future<List<FacultyModel>> _faculties;

  Future<List<FacultyModel>> _getFaculties() async {
    final data = await rootBundle.loadString("assets/data/faculty_details/${widget.department.fileName}.json");
    final json = jsonDecode(data) as List;
    return json.map((e) => FacultyModel.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    _faculties = _getFaculties();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FacultyModel>>(
      future: _faculties,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var facultyList = snapshot.data;
          return Expanded(
            child: ListView.builder(
              itemCount: facultyList!.length,
              itemBuilder: (context, index) {
                var faculty = facultyList[index];
                return FacultyItem(
                  name: faculty.name,
                  designation: faculty.designation,
                  email: faculty.email,
                  experience: faculty.experience,
                  imageUrl: faculty.image,
                  phdGuide: faculty.phdGuide,
                  qualification: faculty.qualification,
                  specialization: faculty.areaOfSpecialization,
                );
              },
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class FacultyItem extends StatelessWidget {
  const FacultyItem({
    Key? key,
    required this.name,
    required this.designation,
    required this.email,
    required this.experience,
    required this.imageUrl,
    required this.phdGuide,
    required this.qualification,
    required this.specialization,
  }) : super(key: key);

  final String name;
  final String designation;
  final String email;
  final String experience;
  final String imageUrl;
  final String phdGuide;
  final String qualification;
  final String specialization;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        width: size.width,
        child: Container(
          width: size.width,
          // padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                blurRadius: 7,
                color: Theme.of(context).colorScheme.background,
              ),
            ],
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  color: Theme.of(context).colorScheme.outline),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(iconColor: Colors.white),
                  header:
                      //  CollapsedFacultyCard(
                      //   name: "$name\n",
                      //   designation: designation,
                      //   imageUrl: imageUrl,
                      // ),
                      CollapsedFacultyCard(
                    name: "$name\n",
                    designation: designation,
                    imageUrl: imageUrl,
                  ),
                  collapsed: SizedBox.shrink(),
                  expanded: ExpandedFacultyCard(
                    // name: "$name\n",
                    //designation: designation,
                    email: email,
                    experience: experience,
                    //imageUrl: imageUrl,
                    phdGuide: phdGuide,
                    qualification: qualification,
                    specialization: specialization,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CollapsedFacultyCard extends StatelessWidget {
  const CollapsedFacultyCard({
    Key? key,
    required this.name,
    required this.designation,
    required this.imageUrl,
  }) : super(key: key);

  final String name;
  final String designation;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(imageUrl),
          radius: 30,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: RichText(
            softWrap: true,
            text: TextSpan(
              text: name,
              style: Theme.of(context).textTheme.titleMedium,
              children: [
                TextSpan(
                  text: designation,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ExpandedFacultyCard extends StatelessWidget {
  const ExpandedFacultyCard({
    Key? key,
    // required this.name,
    // required this.designation,
    required this.email,
    required this.experience,
    //required this.imageUrl,
    required this.phdGuide,
    required this.qualification,
    required this.specialization,
  }) : super(key: key);

  //String name;
  //final String designation;
  final String email;
  final String experience;
  //final String imageUrl;
  final String phdGuide;
  final String qualification;
  final String specialization;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          color: Theme.of(context).colorScheme.outline),
      child: Column(
        children: [
          // CollapsedFacultyCard(
          //   name: name,
          //   designation: designation,
          //   imageUrl: imageUrl,
          // ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                // const Padding(
                //   padding: EdgeInsets.only(top: 20),
                //   child:
                //   Icon(
                //     Icons.email,
                //     size: 25,
                //     color: Colors.white,
                //   ),
                // ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Wrap(
                    direction: Axis.vertical,
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      IconWithChipText(
                        assetPath: 'assets/images/icons/qualifications.png',
                        text: qualification,
                      ),
                      IconWithChipText(
                        assetPath: 'assets/images/icons/experience.png',
                        text: experience,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_border_purple500_outlined,
                            size: 22,
                            color: Color(0xff1FAFA4),
                          ),
                          SizedBox(width: 5),
                          ChipStyledText(
                            text: specialization,
                            width: size.width*.65,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChipStyledText extends StatelessWidget {
  final String text;
  final double? width;
  const ChipStyledText({
    Key? key,
    required this.text,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white54,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.outline,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
      ),
    );
  }
}

class IconWithChipText extends StatelessWidget {
  const IconWithChipText({
    Key? key,
    required this.assetPath,
    required this.text,
  }) : super(key: key);
  final String assetPath;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          assetPath,
          width: 22,
          height: 22,
        ),
        const SizedBox(
          width: 5,
        ),
        ChipStyledText(
          text: text,
          width: MediaQuery.of(context).size.width*.65,
        ),
      ],
    );
  }
}
