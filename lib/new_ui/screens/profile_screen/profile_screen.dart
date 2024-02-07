// ignore_for_file: lines_longer_than_80_chars
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsec_app/models/faculty_model/faculty_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/new_ui/screens/profile_screen/widgets/profile_text_field.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/screens/profile_screen/widgets/custom_text_with_divider.dart';
import 'package:tsec_app/screens/profile_screen/widgets/profile_screen_appbar.dart';
import 'package:tsec_app/screens/profile_screen/widgets/profile_text_field.dart';
import 'package:tsec_app/utils/form_validity.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';
import 'package:tsec_app/utils/image_pick.dart';
import 'package:intl/intl.dart';

class ProfilePage extends ConsumerStatefulWidget {
  bool justLoggedIn;
  ProfilePage({Key? key, required this.justLoggedIn}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String name = "";
  String email = "";
  String image = "";

  final TextEditingController areaOfSpecializationController =
      TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController phdGuideController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();

  String? batch = "";
  String branch = "";
  String? div = "";
  String gradyear = "";
  // String phoneNum = "";
  // String address = "";
  String? profilePicUrl;
  // String dob = "";
  String homeStation = "";
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  Uint8List? profilePic;
  // int _editCount = 0;
  final _formKey = GlobalKey<FormState>();

  String convertFirstLetterToUpperCase(String input) {
    if (input.isEmpty) {
      return input;
    }

    // Convert the entire string to lowercase first
    String lowerCaseInput = input.toLowerCase();

    // Get the first letter and convert it to uppercase
    String firstLetterUpperCase = lowerCaseInput[0].toUpperCase();

    // Combine the first letter with the rest of the lowercase string
    String convertedString = firstLetterUpperCase + lowerCaseInput.substring(1);

    return convertedString;
  }

  List<String> divisionList = [];
  List<String> batchList = [];

  void calcDivisionList(String gradyear) {
    List<String> l = [];
    if (gradyear == "2027") {
      l = ["A", "B", "C", "D", "E", "F", "G", "H", "I"];
    } else if (branch == "Comps") {
      l = ["C1", "C2", "C3"];
    } else if (branch == "Chem") {
      l = ["K"];
    } else if (gradyear == "2026") {
      if (branch == "It" || branch == "Aids") {
        l = ["S1", "S2"];
      } else {
        l = ["A"];
      }
    } else if (gradyear == "2025") {
      if (branch == "It" || branch == "Aids") {
        l = ["T1", "T2"];
      } else {
        l = ["A"];
      }
    } else {
      //2024
      if (branch == "It") {
        l = ["B1", "B2"];
      } else {
        l = ["A"];
      }
    }
    setState(() {
      divisionList = l;
    });
    // debugPrint(gradyear);
    // debugPrint(branch);
    // debugPrint(l.toString());
  }

  String calcGradYear(String gradyear) {
    if (gradyear == "2027") {
      return "First Year";
    } else if (gradyear == "2026") {
      return "Second Year";
    } else if (gradyear == "2025") {
      return "Third Year";
    } else {
      return "Final Year";
    }
  }

  void calcBatchList(String? div) {
    List<String> batches = [];
    if (div == null) {
      setState(() {
        batchList = batches;
      });
      return;
    }
    for (int i = 1; i <= 3; i++) {
      batches.add("$div$i");
    }
    // return batches;
    setState(() {
      batchList = batches;
    });
  }

  // bool loadingImage = false;
  Future editProfileImage(UserModel userModel) async {
    // setState(() {
    //   loadingImage = true;
    // });
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() async {
        image = await ref
            .watch(authProvider.notifier)
            .updateProfilePic(img, userModel);
      });
      // setState(() {
      //   loadingImage = false;
      // });
    } else {
      // setState(() {
      //   loadingImage = false;
      // });
    }
    // setState(() {
    //   _image = image;
    // });
  }

  @override
  void initState() {
    super.initState();
    final UserModel? data = ref.read(userModelProvider);
    if (data != null && data.isStudent) {
      StudentModel studentData = data.studentModel!;
      name = studentData.name;
      email = studentData.email;
      image = studentData.image ?? "";
      gradyear = studentData.gradyear;
      branch = studentData.branch;
      // phoneNum = data.phoneNum ?? "";
      phoneNoController.text = studentData.phoneNum ?? "";
      addressController.text = studentData.address ?? "";
      // address = data.address ?? '';
      homeStation = studentData.homeStation ?? '';
      dobController.text = studentData.dateOfBirth ?? "";
      calcDivisionList(studentData.gradyear);
      div = divisionList.contains(studentData.div)
          ? studentData.div
          : divisionList[0];
      calcBatchList(div);
      batch = batchList.contains(studentData.batch)
          ? studentData.batch
          : batchList[0];
    } else if (data != null) {
      FacultyModel facultyData = data.facultyModel!;
      name = facultyData.name;
      email = facultyData.email;
      image = facultyData.image;
      areaOfSpecializationController.text = facultyData.areaOfSpecialization;
      designationController.text = facultyData.designation;
      experienceController.text = facultyData.experience;
      phdGuideController.text = facultyData.phdGuide;
      qualificationController.text = facultyData.qualification;
    }
  }

  void clearValues(UserModel data) {
    setState(() {
      if (data.isStudent) {
        phoneNoController.text = data.studentModel?.phoneNum ?? "";
        addressController.text = data.studentModel?.address ?? "";
        dobController.text = data.studentModel?.dateOfBirth ?? "";
      } else {
        areaOfSpecializationController.text =
            data.facultyModel?.areaOfSpecialization ?? "";
        designationController.text = data.facultyModel?.designation ?? "";
        experienceController.text = data.facultyModel?.experience ?? "";
        phdGuideController.text = data.facultyModel?.phdGuide ?? "";
        qualificationController.text = data.facultyModel?.qualification ?? "";
      }
      // batch = data.batch;
      // calcBatchList(data.div);
      // calcDivisionList(data.gradyear);
      // div = divisionList.contains(data.div)
      //     ? data.div
      //     : "";
      // batch = batchList.contains(data.batch)
      //     ? data.batch
      //     : "";
      editMode = false;
    });
  }

  Future saveChanges(WidgetRef ref) async {
    final UserModel data = ref.watch(userModelProvider)!;
    if (data.isStudent) {
      // bool canUpdate = data!.updateCount != null ? data.updateCount! < 2 : true;
      bool canUpdate = true;

      if (canUpdate) {
        if (batch == null || div == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Choose an appropriate value for division and batch'),
            ),
          );
          return false;
        }

        StudentModel studentData = data.studentModel!;
        if (studentData.updateCount == null) {
          studentData.updateCount = 1;
        } else {
          int num = studentData.updateCount!;
          studentData.updateCount = num + 1;
        }
        // debugPrint("in here ${address} ${dobController.text} ${batch} ${name}");
        StudentModel student = StudentModel(
          div: div,
          batch: batch,
          branch: convertFirstLetterToUpperCase(branch),
          name: name,
          email: email,
          gradyear: gradyear,
          image: image,
          phoneNum: phoneNoController.text,
          updateCount: studentData.updateCount,
          address: addressController.text,
          homeStation: homeStation,
          dateOfBirth: dobController.text,
        );

        if (_formKey.currentState!.validate()) {
          await ref
              .watch(authProvider.notifier)
              .updateStudentDetails(student, ref, context);
          // setState(() {
          //   _isEditMode = false;
          // });
          setState(() {
            editMode = false;
          });
          return true;
        }
        return false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'You have already updated your profile as many times as possible'),
          ),
        );
      }
    } else {
      FacultyModel faculty = FacultyModel(
        areaOfSpecializationController.text,
        designationController.text,
        email,
        experienceController.text,
        image,
        name,
        phdGuideController.text,
        qualificationController.text,
      );
      if (_formKey.currentState?.validate() ?? false) {
        ref
            .watch(authProvider.notifier)
            .updateFacultyDetails(faculty, ref, context);
        // setState(() {
        //   _isEditMode = false;
        // });
        setState(() {
          editMode = false;
        });
        return true;
      }
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildProfileImage(WidgetRef ref, UserModel data) {
    profilePic = ref.watch(profilePicProvider);
    return GestureDetector(
      onTap: () {
        editProfileImage(data);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          profilePic != null
              ? CircleAvatar(
                  radius: 70,
                  backgroundImage: MemoryImage(profilePic!),
                  // backgroundImage: MemoryImage(_image!),
                )
              : const CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage("assets/images/pfpholder.jpg"),
                ),
          Positioned(
              bottom: 0,
              right: -40,
              child: RawMaterialButton(
                onPressed: () {
                  editProfileImage(data);
                },
                elevation: 2.0,
                fillColor: Color(0xFFF5F6F9),
                child: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
                padding: EdgeInsets.all(3.0),
                shape: CircleBorder(side: BorderSide(color: Colors.black)),
              )),
        ],
      ),
    );
  }

  bool editMode = false;
  @override
  Widget build(BuildContext context) {
    final UserModel data = ref.watch(userModelProvider)!;
    debugPrint("user data is $data");
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: widget.justLoggedIn
          ? AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust the border radius as needed
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      bool changesSaved = await saveChanges(ref);
                      if (changesSaved) GoRouter.of(context).go('/main');
                    },
                  ),
                ),
              ],
            )
          : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                height: MediaQuery.of(context).size.height * .7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.isStudent
                                          ? data.studentModel!.name
                                          : data.facultyModel!.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    data.isStudent
                                        ? SizedBox(height: 15)
                                        : SizedBox(),
                                    data.isStudent
                                        ? Text(
                                            "${data.studentModel!.branch}, ${calcGradYear(data.studentModel!.gradyear)}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          )
                                        : Container(),
                                  ],
                                ),
                                AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 300),
                                  crossFadeState: !editMode
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstChild: RawMaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        editMode = true;
                                      });
                                    },
                                    elevation: 2.0,
                                    fillColor: Color(0xFFF5F6F9),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                    constraints: BoxConstraints.tightFor(
                                      width: 50, // Set the width
                                      height: 50.0, // Set the height
                                    ),
                                    shape: CircleBorder(
                                      side: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  secondChild: Row(children: [
                                    RawMaterialButton(
                                      onPressed: () {
                                        clearValues(data);
                                      },
                                      elevation: 2.0,
                                      fillColor: Color(0xFFF5F6F9),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                      constraints: BoxConstraints.tightFor(
                                        width: 40, // Set the width
                                        height: 40.0, // Set the height
                                      ),
                                      shape: CircleBorder(
                                        side: BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    RawMaterialButton(
                                      onPressed: () async {
                                        bool changesSaved =
                                            await saveChanges(ref);
                                        // if (changesSaved)
                                        //   GoRouter.of(context).go('/main');
                                      },
                                      elevation: 2.0,
                                      fillColor: Color(0xFFF5F6F9),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.black,
                                      ),
                                      constraints: BoxConstraints.tightFor(
                                        width: 40, // Set the width
                                        height: 40.0, // Set the height
                                      ),
                                      shape: CircleBorder(
                                        side: BorderSide(color: Colors.black),
                                      ),
                                    )
                                  ]),
                                )
                              ],
                            ),
                            SizedBox(height: 40),
                            Form(
                              key: _formKey,
                              child: data.isStudent
                                  ? Column(
                                      children: [
                                        ProfileField(
                                          labelName: "Email",
                                          enabled: false,
                                          value: email,
                                          onChanged: (val) {
                                            setState(() {
                                              email = val;
                                            });
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        ProfileField(
                                          labelName: "Number",
                                          enabled: editMode,
                                          controller: phoneNoController,
                                          // onChanged: (val) {
                                          //   setState(() {
                                          //     phoneNum = val;
                                          //   });
                                          // },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a phone number';
                                            }
                                            if (!isValidPhoneNumber(value)) {
                                              return 'Please enter a valid phone number';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        ProfileField(
                                          labelName: "DOB",
                                          enabled: editMode,
                                          readOnly: true,
                                          controller: dobController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now()
                                                  .subtract(
                                                      Duration(days: 20 * 365)),
                                              firstDate: DateTime(1960),
                                              lastDate: DateTime(2010),
                                            );
                                            if (pickedDate != null) {
                                              String formattedDate =
                                                  DateFormat('d MMMM y')
                                                      .format(pickedDate);

                                              // setState(() {
                                              dobController.text =
                                                  formattedDate;
                                            } else {
                                              // print(
                                              //     "Date is not selected");
                                            }
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter Date Of Birth';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        ProfileField(
                                          labelName: "Address",
                                          enabled: editMode,
                                          // value: address,
                                          controller: addressController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter an address';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: editMode
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 4, 12, 4),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Division",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                SizedBox(width: 25),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .6,
                                                  child:
                                                      DropdownButtonFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                                    value: div,
                                                    validator: (value) {
                                                      if (value == "") {
                                                        return 'Please enter a division';
                                                      }
                                                      return null;
                                                    },
                                                    dropdownColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                    items: divisionList
                                                        .map((String item) {
                                                      return DropdownMenuItem(
                                                        value: item,
                                                        child: Text(
                                                          item,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),

                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                    // After selecting the desired option,it will
                                                    // change button value to selected value
                                                    onChanged: editMode
                                                        ? (String? newValue) {
                                                            if (newValue !=
                                                                null) {
                                                              setState(() {
                                                                div = newValue;
                                                                calcBatchList(
                                                                    newValue);
                                                                batch = null;
                                                              });
                                                            }
                                                          }
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: editMode
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 4, 12, 4),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Batch",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                SizedBox(width: 25),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .6,
                                                  child:
                                                      DropdownButtonFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                                    value: batch,
                                                    validator: (value) {
                                                      if (value == "") {
                                                        return 'Please enter a batch';
                                                      }
                                                      return null;
                                                    },
                                                    dropdownColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                    items: batchList
                                                        .map((String item) {
                                                      return DropdownMenuItem(
                                                        value: item,
                                                        child: Text(
                                                          item,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),

                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                    // After selecting the desired option,it will
                                                    // change button value to selected value
                                                    onChanged: editMode
                                                        ? (String? newValue) {
                                                            if (newValue !=
                                                                null) {
                                                              setState(() {
                                                                batch =
                                                                    newValue;
                                                                // calcBatchList(newValue);
                                                                // batch = null;
                                                              });
                                                            }
                                                          }
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        ProfileField(
                                          labelName: "Email",
                                          enabled: false,
                                          value: email,
                                          onChanged: (val) {
                                            setState(() {
                                              email = val;
                                            });
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        ProfileField(
                                          labelName: "Designation",
                                          enabled: editMode,
                                          controller: designationController,
                                          // onChanged: (val) {
                                          //   setState(() {
                                          //     phoneNum = val;
                                          //   });
                                          // },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a designation';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        ProfileField(
                                          labelName: "Phd Guide",
                                          enabled: editMode,
                                          controller: phdGuideController,
                                          // onChanged: (val) {
                                          //   setState(() {
                                          //     phoneNum = val;
                                          //   });
                                          // },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter the name of your phd guide';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        ProfileField(
                                          labelName: "Qualification",
                                          enabled: editMode,
                                          controller: qualificationController,
                                          // onChanged: (val) {
                                          //   setState(() {
                                          //     phoneNum = val;
                                          //   });
                                          // },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your qualifications';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        ProfileField(
                                          labelName: "Experience",
                                          enabled: editMode,
                                          // value: address,
                                          controller: experienceController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a value';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        ProfileField(
                                          labelName: "Area of specialization",
                                          enabled: editMode,
                                          // value: address ,
                                          controller:
                                              areaOfSpecializationController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a value';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -50,
                child: Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 4,
                      ),
                    ),
                    child: buildProfileImage(ref, data),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
