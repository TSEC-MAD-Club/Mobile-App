// ignore_for_file: lines_longer_than_80_chars

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/screens/profile_screen/widgets/customTextWithDivider.dart';
import 'package:tsec_app/screens/profile_screen/widgets/profile_screen_appbar.dart';
import 'package:tsec_app/screens/profile_screen/widgets/profile_text_field.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';
import '../../utils/image_pick.dart';
import '../../utils/themes.dart';
import 'package:intl/intl.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _batchController = TextEditingController();
  // final TextEditingController _branchController = TextEditingController();
  // final TextEditingController _divController = TextEditingController();
  // final TextEditingController _gradyearController = TextEditingController();
  // final TextEditingController _phoneNumController = TextEditingController();
  // final TextEditingController _addressController = TextEditingController();
  // final TextEditingController _homeStationController = TextEditingController();
  // final TextEditingController _dateOfBirthController = TextEditingController();

  String name = "";
  String email = "";
  String? batch = "";
  String branch = "";
  String? div = "";
  String gradyear = "";
  String phoneNum = "";
  String address = "";
  String homeStation = "";
  // String dob = "";

  final TextEditingController _dobController = TextEditingController();

  Uint8List? _image;
  int _editCount = 0;
  bool _isEditMode = false;
  final _formKey = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  void enableEditing() {
    setState(() {
      _isEditMode = true;
    });
  }

  void editProfileImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

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

  void _saveChanges(WidgetRef ref) async {
    final StudentModel? data = ref.watch(studentModelProvider);
    bool b = data!.updateCount != null ? data.updateCount! < 2 : true;
    // if (b) {
    if (batch == null || div == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choose an appropriate value for division and batch'),
        ),
      );
      return;
    }

    if (data.updateCount == null) {
      data.updateCount = 1;
    } else {
      int num = data.updateCount!;
      data.updateCount = num + 1;
    }
    // debugPrint("in here ${address} ${_dobController.text} ${batch} ${name}");
    StudentModel student = StudentModel(
      div: div,
      batch: batch,
      branch: convertFirstLetterToUpperCase(branch),
      name: name,
      email: email,
      gradyear: gradyear,
      phoneNum: phoneNum,
      updateCount: data.updateCount,
      address: address,
      homeStation: homeStation,
      // dateOfBirth: dob,
      dateOfBirth: _dobController.text,
    );

    if (_formKey.currentState!.validate()) {
      ref.watch(authProvider.notifier).updateUserDetails(student, ref, context);
      setState(() {
        _isEditMode = false;
      });
    }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text(
    //           'You have already updated your profile as many times as possible'),
    //     ),
    //   );
    // }
  }

  ScrollController listScrollController = ScrollController();

  @override
  void dispose() {
    // _addressController.dispose();
    // _batchController.dispose();
    // _branchController.dispose();
    // _dateOfBirthController.dispose();
    // _divController.dispose();
    // _emailController.dispose();
    // _gradyearController.dispose();
    // _homeStationController.dispose();
    // _nameController.dispose();
    // _phoneNumController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final StudentModel? data = ref.read(studentModelProvider);
    name = data!.name;
    email = data.email;
    batch = data.batch;
    branch = data.branch;
    div = data.div;
    // div = null;
    gradyear = data.gradyear;
    batch = data.batch;
    // batch = null;
    phoneNum = data.phoneNum;
    address = data.address ?? '';
    homeStation = data.homeStation ?? '';
    _dobController.text = data.dateOfBirth ?? "";
    calcBatchList(data.div);
    calcDivisionList(data.gradyear);
  }

  @override
  Widget build(BuildContext context) {
    final StudentModel? data = ref.watch(studentModelProvider);
    // name = data!.name;
    // _nameController.text = data!.name;
    // _emailController.text = data.email;
    // _batchController.text = data.batch;
    // _branchController.text = data.branch.toUpperCase();
    // _divController.text = data.div;
    // _gradyearController.text = data.gradyear;
    // _phoneNumController.text = data.phoneNum;
    // _addressController.text = data.address ?? '';
    // _homeStationController.text = data.homeStation ?? '';
    // _dateOfBirthController.text = data.dateOfBirth ?? '';

    // name = data.name;
    // email = data.email;
    // batch = data.batch;
    // branch = data.branch.toUpperCase();
    // div = data.div;
    // gradyear = data.gradyear;
    // batch = data.batch;
    // phoneNum = data.phoneNum;
    // address = data.address ?? '';
    // homeStation = data.homeStation ?? '';
    // dob = data.dateOfBirth ?? '';

    return CustomScaffold(
      hideButton: _isEditMode,
      appBar: const ProfilePageAppBar(title: "Profile"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: listScrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    // child: Form(
                    //   child: Stack(
                    // alignment: Alignment.center,
                    // children: [
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: double.infinity,
                                    height: 100,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/tsecimage2.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -30,
                                  child: Container(
                                    width:
                                        90, // Adjust the width and height as needed
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        width:
                                            4, // Adjust the border width as needed
                                      ),
                                    ),
                                    child: buildProfileImages(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              data!.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              data.homeStation ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      color:
                                          Color.fromARGB(255, 171, 171, 171)),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                        // isBlurred
                        //     ? BackdropFilter(
                        //         filter:
                        //             ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        //         child: SizedBox(
                        //           width: double.infinity,
                        //           height: double.infinity,
                        //         ),
                        //       )
                        //     : const SizedBox.shrink(),
                        Padding(
                          padding: EdgeInsets.only(top: 200),
                          child: Column(
                            children: [
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: _isEditMode ? 10.0 : 0.0,
                                  sigmaY: _isEditMode ? 10.0 : 0.0,
                                ),
                                child: AnimatedCrossFade(
                                  duration: const Duration(seconds: 1),
                                  firstChild: Container(
                                    height: 460,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xFF454545)),
                                      color: Color(0xFF323232),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWithDivider(
                                          label: "Email",
                                          value: data!.email,
                                          showDivider: true,
                                        ),
                                        // Divider(
                                        //   thickness: 1,
                                        //   color: Colors.grey.shade800,
                                        // ),
                                        CustomTextWithDivider(
                                          label: "Phone Number",
                                          value: data.phoneNum,
                                          showDivider: true,
                                        ),
                                        // Divider(
                                        //   thickness: 1,
                                        //   color: Color(0xFF454545),
                                        // ),
                                        CustomTextWithDivider(
                                          label: "Date of Birth",
                                          value: data.dateOfBirth ?? " ",
                                          showDivider: true,
                                        ),
                                        // Divider(
                                        //   thickness: 1,
                                        //   color: Color(0xFF454545),
                                        // ),
                                        CustomTextWithDivider(
                                          label: "Branch",
                                          value: data.branch,
                                          showDivider: true,
                                        ),
                                        // Divider(
                                        //   thickness: 1,
                                        //   color: Color(0xFF454545),
                                        // ),
                                        CustomTextWithDivider(
                                          label: "Graduation Year",
                                          value: data.gradyear,
                                          showDivider: true,
                                        ),
                                        // Divider(
                                        //   thickness: 1,
                                        //   color: Colors.grey.shade800,
                                        // ),
                                        CustomTextWithDivider(
                                          label: "Division",
                                          value: data.div ?? "-",
                                          showDivider: true,
                                        ),
                                        // Divider(
                                        //   thickness: 1,
                                        //   color: Colors.grey.shade800,
                                        // ),
                                        CustomTextWithDivider(
                                          label: "Batch",
                                          value: data.batch ?? "-",
                                          showDivider: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                  secondChild: Container(
                                    height: 580,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xFF454545)),
                                      color: Color(0xFF323232),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Scrollbar(
                                            //   thumbVisibility: true,
                                            child: SingleChildScrollView(
                                              child: Form(
                                                key: _formKey,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // ProfileTextField(
                                                    //   isEditMode: _isEditMode,
                                                    //   label: "Name",
                                                    //   controller:
                                                    //       _nameController,
                                                    //   initVal: name,
                                                    //   onSaved: (newVal) {
                                                    //     setState(() {
                                                    //       name = newVal;
                                                    //     });
                                                    //   },
                                                    //   validator: (value) {
                                                    //     if (value!.isEmpty) {
                                                    //       return 'Please enter a name';
                                                    //     }
                                                    //     return null;
                                                    //   },
                                                    // ),
                                                    ProfileTextField(
                                                      // onChanged: (val) {
                                                      //   widget.controller.text = val;
                                                      // },
                                                      initVal: name,
                                                      isEditMode: _isEditMode,
                                                      onSaved: (newVal) {
                                                        setState(() {
                                                          if (newVal != null) {
                                                            name = newVal;
                                                          }
                                                        });
                                                      },
                                                      label: "Name",
                                                    ),
                                                    ProfileTextField(
                                                      isEditMode: _isEditMode,
                                                      label: "Email",
                                                      // controller:
                                                      //     _emailController,
                                                      initVal: email,
                                                      onSaved: (newVal) {
                                                        setState(() {
                                                          if (newVal != null) {
                                                            email = newVal;
                                                          }
                                                        });
                                                      },
                                                      enabled: false,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter an email';
                                                        }
                                                        if (!isValidEmail(
                                                            value)) {
                                                          return 'Please enter a Valid Email';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                    ProfileTextField(
                                                      // controller:
                                                      //     _addressController,

                                                      initVal: address,
                                                      onSaved: (newVal) {
                                                        setState(() {
                                                          if (newVal != null) {
                                                            address = newVal;
                                                          }
                                                        });
                                                      },
                                                      label: 'Address',
                                                      isEditMode: _isEditMode,
                                                      // validator: (value) {
                                                      //   if (value!.isEmpty) {
                                                      //     return 'Please enter your Address';
                                                      //   }
                                                      //   return null;
                                                      // },
                                                    ),
                                                    // ProfileTextField(
                                                    //   // controller:
                                                    //   //     _homeStationController,

                                                    //   initVal: homeStation,
                                                    //   onSaved: (newVal) {
                                                    //     setState(() {
                                                    //       if (newVal != null) {
                                                    //         homeStation =
                                                    //             newVal;
                                                    //       }
                                                    //     });
                                                    //   },
                                                    //   label: 'Home Station',
                                                    //   isEditMode: _isEditMode,
                                                    //   validator: (value) {
                                                    //     if (value!.isEmpty) {
                                                    //       return 'Please enter your Home Station';
                                                    //     }
                                                    //     return null;
                                                    //   },
                                                    // ),
                                                    // ProfileTextField(
                                                    //   // controller:
                                                    //   //     _dateOfBirthController,
                                                    //   isEditMode: _isEditMode,
                                                    //   label: "Date of Birth",
                                                    //   initVal: dob,
                                                    //   // onSaved: (newVal) {
                                                    //   //   setState(() {
                                                    //   //     if (newVal != null) {
                                                    //   //       dob = newVal;
                                                    //   //     }
                                                    //   //   });
                                                    //   // },
                                                    //   readOnly: true,
                                                    //   // validator: (value) {
                                                    //   //   if (value!.isEmpty) {
                                                    //   //     return 'Please enter Date Of Birth';
                                                    //   //   }
                                                    //   //   // Regular expression to match the desired DOB format: 20 August 2003
                                                    //   //   const pattern =
                                                    //   //       r'^(0[1-9]|[12][0-9]|3[01]) (January|February|March|April|May|June|July|August|September|October|November|December) \d{4}$';
                                                    //   //   final regex =
                                                    //   //       RegExp(pattern);

                                                    //   //   if (!regex
                                                    //   //       .hasMatch(value)) {
                                                    //   //     return 'Invalid Date Of Birth format. Please use the format: 20 August 2003';
                                                    //   //   }

                                                    //   //   return null;
                                                    //   // },
                                                    //   onTap: () async {
                                                    //     DateTime? pickedDate =
                                                    //         await showDatePicker(
                                                    //       context: context,
                                                    //       initialDate: DateTime
                                                    //               .now()
                                                    //           .subtract(Duration(
                                                    //               days: 20 *
                                                    //                   365)), //get today's date
                                                    //       firstDate: DateTime(
                                                    //           1960), //DateTime.now() - not to allow to choose before today.
                                                    //       lastDate:
                                                    //           DateTime(2010),
                                                    //     );
                                                    //     if (pickedDate !=
                                                    //         null) {
                                                    //       String formattedDate =
                                                    //           DateFormat(
                                                    //                   'd MMMM y')
                                                    //               .format(
                                                    //                   pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                    //       // print(
                                                    //       //     formattedDate); //formatted date output using intl package =>  2022-07-04
                                                    //       //You can format date as per your need

                                                    //       setState(() {
                                                    //         dob =
                                                    //             formattedDate; //set foratted date to TextField value.
                                                    //       });
                                                    //     } else {
                                                    //       // print(
                                                    //       //     "Date is not selected");
                                                    //     }
                                                    //   },
                                                    // ),

                                                    TextFormField(
                                                      readOnly: true,
                                                      controller:
                                                          _dobController,
                                                      // onChanged: (val) {
                                                      //   widget.controller.text = val;
                                                      // },
                                                      // initialValue: widget.initVal,
                                                      // onSaved: widget.onSaved,
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0xFF454545),
                                                          ), // Change to your desired color
                                                        ),
                                                        labelStyle:
                                                            const TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                        labelText:
                                                            "Date of Birth",
                                                      ),
                                                      onTap: () async {
                                                        DateTime? pickedDate =
                                                            await showDatePicker(
                                                          context: context,
                                                          initialDate: DateTime
                                                                  .now()
                                                              .subtract(Duration(
                                                                  days: 20 *
                                                                      365)), //get today's date
                                                          firstDate: DateTime(
                                                              1960), //DateTime.now() - not to allow to choose before today.
                                                          lastDate:
                                                              DateTime(2010),
                                                        );
                                                        if (pickedDate !=
                                                            null) {
                                                          String formattedDate =
                                                              DateFormat(
                                                                      'd MMMM y')
                                                                  .format(
                                                                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                          // print(
                                                          //     formattedDate); //formatted date output using intl package =>  2022-07-04
                                                          //You can format date as per your need

                                                          // setState(() {
                                                          _dobController.text =
                                                              formattedDate; //set foratted date to TextField value.
                                                          // });
                                                        } else {
                                                          // print(
                                                          //     "Date is not selected");
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter Date Of Birth';
                                                        }
                                                        // Regular expression to match the desired DOB format: 20 August 2003
                                                        const pattern =
                                                            r'^(0[1-9]|[12][0-9]|3[01]) (January|February|March|April|May|June|July|August|September|October|November|December) \d{4}$';
                                                        final regex =
                                                            RegExp(pattern);

                                                        if (!regex
                                                            .hasMatch(value)) {
                                                          return 'Invalid Date Of Birth format. Please use the format: 20 August 2003';
                                                        }

                                                        return null;
                                                      },
                                                      // initialValue: dob,
                                                      // onSaved: widget.onSaved ?? (val) {},
                                                    ),
                                                    ProfileTextField(
                                                      isEditMode: _isEditMode,
                                                      label: "Phone Number",
                                                      // controller:
                                                      //     _phoneNumController,
                                                      initVal: phoneNum,
                                                      onSaved: (newVal) {
                                                        setState(() {
                                                          if (newVal != null) {
                                                            phoneNum = newVal;
                                                          }
                                                        });
                                                      },
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter a phone number';
                                                        }
                                                        if (!isValidPhoneNumber(
                                                            value)) {
                                                          return 'Please enter a valid phone number';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                    ProfileTextField(
                                                      isEditMode: _isEditMode,
                                                      label: "Branch",
                                                      // controller:
                                                      //     _branchController,
                                                      initVal: branch,
                                                      onSaved: (newVal) {
                                                        setState(() {
                                                          if (newVal != null) {
                                                            branch = newVal;
                                                          }
                                                        });
                                                      },
                                                      enabled: true,
                                                    ),
                                                    ProfileTextField(
                                                      isEditMode: _isEditMode,
                                                      initVal: gradyear,
                                                      label:
                                                          "Graduation Year", // decoration: BoxDecoration(
                                                      //   border: Border.all(color: Color(0xFF454545)),
                                                      //   color: Color(0xFF323232),
                                                      //   borderRadius: BorderRadius.circular(30),
                                                      // ),
                                                      // controller:
                                                      //     _gradyearController,

                                                      onSaved: (newVal) {
                                                        setState(() {
                                                          if (newVal != null) {
                                                            gradyear = newVal;
                                                          }
                                                        });
                                                      },
                                                      enabled: true,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  4, 5, 4, 5),
                                                          child: DropdownButton(
                                                            // Initial Value
                                                            value: div,
                                                            hint: Text(
                                                              "Division",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),

                                                            underline:
                                                                Container(
                                                              height: 1,
                                                              color: Color(
                                                                  0xFF454545), // Change to your desired color
                                                            ),
                                                            dropdownColor: Theme
                                                                    .of(context)
                                                                .primaryColor,
                                                            icon: const Icon(Icons
                                                                .keyboard_arrow_down),

                                                            // Array list of items
                                                            items: divisionList
                                                                .map((String
                                                                    items) {
                                                              return DropdownMenuItem(
                                                                value: items,
                                                                child:
                                                                    Text(items),
                                                              );
                                                            }).toList(),
                                                            // After selecting the desired option,it will
                                                            // change button value to selected value
                                                            onChanged: (String?
                                                                newValue) {
                                                              if (newValue !=
                                                                  null) {
                                                                setState(() {
                                                                  div =
                                                                      newValue;
                                                                  calcBatchList(
                                                                      newValue);
                                                                  batch = null;
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(width: 20),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  4, 5, 4, 5),
                                                          child: DropdownButton(
                                                            // Initial Value
                                                            value: batch,

                                                            hint: Text(
                                                              "Batch",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            underline:
                                                                Container(
                                                              height: 1,
                                                              color: Color(
                                                                  0xFF454545), // Change to your desired color
                                                            ),
                                                            dropdownColor: Theme
                                                                    .of(context)
                                                                .primaryColor,
                                                            // Down Arrow Icon
                                                            icon: const Icon(Icons
                                                                .keyboard_arrow_down),

                                                            // Array list of items
                                                            items: batchList
                                                                .map((String
                                                                    items) {
                                                              return DropdownMenuItem(
                                                                value: items,
                                                                child:
                                                                    Text(items),
                                                              );
                                                            }).toList(),
                                                            // After selecting the desired option,it will
                                                            // change button value to selected value
                                                            onChanged: (String?
                                                                newValue) {
                                                              if (newValue !=
                                                                  null) {
                                                                setState(() {
                                                                  batch =
                                                                      newValue;
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // ProfileTextField(
                                                    //   isEditMode: _isEditMode,
                                                    //   label: "Division",
                                                    //   // controller:
                                                    //   //     _divController,
                                                    //   initVal: div,

                                                    //   onSaved: (newVal) {
                                                    //     setState(() {
                                                    //       if (newVal != null) {
                                                    //         div = newVal;
                                                    //       }
                                                    //     });
                                                    //   },
                                                    // ),
                                                    // ProfileTextField(
                                                    //   isEditMode: _isEditMode,
                                                    //   label: "Batch",
                                                    //   // controller:
                                                    //   //     _batchController,
                                                    //   initVal: batch,
                                                    //   onSaved: (newVal) {
                                                    //     setState(() {
                                                    //       if (newVal != null) {
                                                    //         batch = newVal;
                                                    //       }
                                                    //     });
                                                    //   },
                                                    //   validator: (value) {
                                                    //     if (value!.isEmpty) {
                                                    //       return 'Please enter a batch';
                                                    //     }
                                                    //     if (value.length != 3) {
                                                    //       return 'Batch should be a single capital letter followed by two digits';
                                                    //     }
                                                    //     final batchRegex = RegExp(
                                                    //         r'^[A-Z][0-9]{2}$');
                                                    //     if (!batchRegex
                                                    //         .hasMatch(value)) {
                                                    //       return 'Batch should be a single capital letter followed by two digits';
                                                    //     }
                                                    //     return null;
                                                    //   },
                                                    //   enabled: _isEditMode,
                                                    // ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Spacer(),
                                            ElevatedButton(
                                              onPressed: () {
                                                if (_isEditMode) {
                                                  _saveChanges(ref);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0), // Half of desired button height
                                                ),
                                              ),
                                              child: const Text(
                                                "Save Changes",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),

                                            Spacer(),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  // isExpanded = false;
                                                  // isBlurred = false;
                                                  _isEditMode = false;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.white,
                                                size: 30,
                                              ), // Use Icon widget to specify the icon
                                            ),
                                            // SizedBox(
                                            //   width: 10,
                                            // )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  crossFadeState: !_isEditMode
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          !_isEditMode
              ? Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_isEditMode) {
                        // enableEditing();
                        setState(() {
                          // isExpanded = true;
                          // isBlurred = true;
                          _isEditMode = true;
                        });
                        Future.delayed(Duration(milliseconds: 1000), () {
                          if (listScrollController.hasClients) {
                            final position =
                                listScrollController.position.viewportDimension;
                            listScrollController.animateTo(
                              position,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            50.0), // Half of desired button height
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: //Text(_isEditMode ? 'Save Changes' : 'Edit'),
                        const Text("EDIT"),
                  ),
                )
              : Container(),
        ],
      ),
      // Positioned(
      //   bottom: 0,
      //   left: 10,
      //   right: 10,
      //   child: Form(
      //     key: _formKey,
      //     child: isExpanded
      //         ? AnimatedContainer(
      //             duration: const Duration(milliseconds: 500),
      //             curve: Curves.easeInOut,
      //             width: 500,
      //             height: 680,
      //             //padding: const EdgeInsets.only(top: 10),
      //             decoration: BoxDecoration(
      //               border: Border.all(color: Colors.grey.shade800),
      //               color: Theme.of(context).primaryColor,
      //               borderRadius: BorderRadius.circular(30),
      //             ),
      //             child: Padding(
      //               padding: const EdgeInsets.all(10.0),
      //               child: Column(
      //                 children: [
      //                   ProfileTextField(
      //                     isEditMode: _isEditMode,
      //                     label: "Name",
      //                     controller: _nameController,
      //                     validator: (value) {
      //                       if (value!.isEmpty) {
      //                         return 'Please enter a name';
      //                       }
      //                       return null;
      //                     },
      //                   ),
      //                   ProfileTextField(
      //                     isEditMode: _isEditMode,
      //                     label: "Email",
      //                     controller: _emailController,
      //                     validator: (value) {
      //                       if (value!.isEmpty) {
      //                         return 'Please enter an email';
      //                       }
      //                       if (!isValidEmail(value)) {
      //                         return 'Please enter a Valid Email';
      //                       }
      //                       return null;
      //                     },
      //                   ),
      //                   ProfileTextField(
      //                     controller: _addressController,
      //                     label: 'Address',
      //                     isEditMode: _isEditMode,
      //                     validator: (value) {
      //                       if (value!.isEmpty) {
      //                         return 'Please enter your Address';
      //                       }
      //                       return null;
      //                     },
      //                   ),
      //                   ProfileTextField(
      //                     controller: _homeStationController,
      //                     label: 'Home Station',
      //                     isEditMode: _isEditMode,
      //                     validator: (value) {
      //                       if (value!.isEmpty) {
      //                         return 'Please enter your Home Station';
      //                       }
      //                       return null;
      //                     },
      //                   ),
      //                   ProfileTextField(
      //                     controller: _dateOfBirthController,
      //                     label: 'Date of Birth',
      //                     isEditMode: _isEditMode,
      //                     validator: (value) {
      //                       if (value!.isEmpty) {
      //                         return 'Please enter Date Of Birth';
      //                       }
      //                       // Regular expression to match the desired DOB format: 20 August 2003
      //                       const pattern =
      //                           r'^(0[1-9]|[12][0-9]|3[01]) (January|February|March|April|May|June|July|August|September|October|November|December) \d{4}$';
      //                       final regex = RegExp(pattern);

      //                       if (!regex.hasMatch(value)) {
      //                         return 'Invalid Date Of Birth format. Please use the format: 20 August 2003';
      //                       }

      //                       return null;
      //                     },
      //                   ),
      //                   ProfileTextField(
      //                     isEditMode: _isEditMode,
      //                     label: "Phone Number",
      //                     controller: _phoneNumController,
      //                     validator: (value) {
      //                       if (value!.isEmpty) {
      //                         return 'Please enter a phone number';
      //                       }
      //                       if (!isValidPhoneNumber(value)) {
      //                         return 'Please enter a valid phone number';
      //                       }
      //                       return null;
      //                     },
      //                   ),
      //                   ProfileTextField(
      //                     isEditMode: _isEditMode,
      //                     label: "Branch",
      //                     controller: _branchController,
      //                     enabled: false,
      //                   ),
      //                   ProfileTextField(
      //                     isEditMode: _isEditMode,
      //                     label: "Graduation Year",
      //                     controller: _gradyearController,
      //                     enabled: false,
      //                   ),
      //                   ProfileTextField(
      //                     isEditMode: _isEditMode,
      //                     label: "Division",
      //                     controller: _divController,
      //                   ),
      //                   ProfileTextField(
      //                     isEditMode: _isEditMode,
      //                     label: "Batch",
      //                     controller: _batchController,
      //                     validator: (value) {
      //                       if (value!.isEmpty) {
      //                         return 'Please enter a batch';
      //                       }
      //                       if (value.length != 3) {
      //                         return 'Batch should be a single capital letter followed by two digits';
      //                       }
      //                       final batchRegex = RegExp(r'^[A-Z][0-9]{2}$');
      //                       if (!batchRegex.hasMatch(value)) {
      //                         return 'Batch should be a single capital letter followed by two digits';
      //                       }
      //                       return null;
      //                     },
      //                     enabled: _isEditMode,
      //                   ),
      //                   const SizedBox(
      //                     height: 15,
      //                   ),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       ElevatedButton(
      //                           onPressed: () {
      //                             if (_isEditMode) {
      //                               _saveChanges(ref);
      //                             }
      //                           },
      //                           style: ElevatedButton.styleFrom(
      //                               backgroundColor: Colors.green),
      //                           child: const Text(
      //                             "Save Changes",
      //                           )),
      //                       IconButton(
      //                         onPressed: () {
      //                           setState(() {
      //                             isExpanded = false;
      //                             isBlurred = false;

      //                             _isEditMode = false;
      //                           });
      //                         },
      //                         icon: const Icon(
      //                           Icons.cancel_outlined,
      //                           color: Colors.white,
      //                           size: 30,
      //                         ), // Use Icon widget to specify the icon
      //                       ),
      //                       SizedBox(
      //                         width: 10,
      //                       )
      //                     ],
      //                   )
      //                 ],
      //               ),
      //             ),
      //           )
      //         : Align(
      //             alignment: Alignment.bottomCenter,
      //             child: ElevatedButton(
      //                 onPressed: () {
      //                   if (!_isEditMode) {
      //                     enableEditing();
      //                     setState(() {
      //                       isExpanded = true;
      //                       isBlurred = true;
      //                       _isEditMode = true;
      //                     });
      //                   }
      //                 },
      //                 child: //Text(_isEditMode ? 'Save Changes' : 'Edit'),
      //                     const Text("EDIT")),
      //           ),
      //   ),
      // ),
    );
  }

  Widget buildProfileImages() {
    return Stack(
      children: [
        _image != null
            ? CircleAvatar(
                radius: 50,
                backgroundImage: MemoryImage(_image!),
              )
            : const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/pfpholder.jpg"),
              ),
        Positioned(
          bottom: 0,
          right: -30,
          child: RawMaterialButton(
            onPressed: _isEditMode ? editProfileImage : null,
            elevation: 2.0,
            fillColor: kLightModeShadowColor,
            child: const Icon(
              Icons.edit,
              color: Colors.blue,
            ),
            padding: const EdgeInsets.all(3.0),
            shape: const CircleBorder(),
          ),
        ),
      ],
    );
  }
}
// Widget _buildTextField({
//   required TextEditingController controller,
//   required String label,
//   bool enabled = true,
//   String? Function(String?)? validator,
// }) {
//   return TextFormField(
//     controller: controller,
//     enabled: _isEditMode && enabled,
//     decoration: InputDecoration(
//       labelStyle: const TextStyle(
//         color: Colors.grey,
//       ),
//       border: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey[900] ?? Colors.grey),
//       ),
//       disabledBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey),
//       ),
//       enabledBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.white70),
//       ),
//       labelText: label,
//     ),
//     validator: validator,
//   );
// }
