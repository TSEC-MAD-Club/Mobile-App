// ignore_for_file: lines_longer_than_80_chars
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/screens/profile_screen/widgets/custom_text_with_divider.dart';
import 'package:tsec_app/screens/profile_screen/widgets/profile_screen_appbar.dart';
import 'package:tsec_app/screens/profile_screen/widgets/profile_text_field.dart';
import 'package:tsec_app/utils/form_validity.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';
import '../../utils/image_pick.dart';
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
  String? batch = "";
  String branch = "";
  String? div = "";
  String gradyear = "";
  String phoneNum = "";
  String address = "";
  String homeStation = "";
  String? profilePicUrl;
  // String dob = "";

  final TextEditingController _dobController = TextEditingController();

  Uint8List? profilePic;
  // int _editCount = 0;
  bool _isEditMode = false;
  final _formKey = GlobalKey<FormState>();

  void enableEditing() {
    setState(() {
      _isEditMode = true;
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
      l.add("");
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
      batchList.add("");
      batchList = batches;
    });
  }

  // bool loadingImage = false;
  Future editProfileImage() async {
    // setState(() {
    //   loadingImage = true;
    // });
    Uint8List? image = await pickImage(ImageSource.gallery);
    if (image != null) {
      // await ref.watch(authProvider.notifier).updateProfilePic(image);
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

  Future _saveChanges(WidgetRef ref) async {
    final StudentModel? data = ref.watch(userModelProvider)?.studentModel;
    bool b = data!.updateCount != null ? data.updateCount! < 2 : true;
    // debugPrint("b is $b");
    if (b) {
      if (batch == null || div == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Choose an appropriate value for division and batch'),
          ),
        );
        return false;
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
        image: "",
        batch: batch,
        branch: convertFirstLetterToUpperCase(branch),
        name: name,
        email: email,
        gradyear: gradyear,
        phoneNum: phoneNum,
        updateCount: data.updateCount,
        address: address,
        homeStation: homeStation,
        dateOfBirth: _dobController.text,
      );

      if (_formKey.currentState!.validate()) {
        await ref
            .watch(authProvider.notifier)
            .updateStudentDetails(student, ref, context);
        setState(() {
          _isEditMode = false;
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
  }

  ScrollController listScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final StudentModel? data = ref.read(userModelProvider)?.studentModel;
    name = data!.name;
    email = data.email;
    batch = data.batch;
    branch = data.branch;
    gradyear = data.gradyear;
    phoneNum = data.phoneNum ?? "";
    address = data.address ?? '';
    homeStation = data.homeStation ?? '';
    _dobController.text = data.dateOfBirth ?? "";
    calcBatchList(data.div);
    calcDivisionList(data.gradyear);
    div = divisionList.contains(data.div) ? data.div : "";
    batch = batchList.contains(data.batch) ? data.batch : "";
  }

  Widget buildProfileImages(WidgetRef ref) {
    profilePic = ref.watch(profilePicProvider);
    return GestureDetector(
      onTap: () {
        editProfileImage();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          profilePic != null
              ? CircleAvatar(
                  radius: 50,
                  backgroundImage: MemoryImage(profilePic!),
                  // backgroundImage: MemoryImage(_image!),
                )
              : const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/pfpholder.jpg"),
                ),
          Positioned(
              bottom: 0,
              right: -40,
              child: RawMaterialButton(
                onPressed: () {
                  editProfileImage();
                },
                elevation: 2.0,
                fillColor: const Color(0xFFF5F6F9),
                child: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                padding: const EdgeInsets.all(3.0),
                shape:
                    const CircleBorder(side: BorderSide(color: Colors.black)),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final StudentModel? data = ref.watch(userModelProvider)?.studentModel;

    bool hide = widget.justLoggedIn || _isEditMode;
    // bool hide = _isEditMode;
    return CustomScaffold(
      hideButton: hide,
      //hide the app bar and the floating action button
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
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        width: 4,
                                      ),
                                    ),
                                    child: buildProfileImages(ref),
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
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 200),
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
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      // border:
                                      //     Border.all(color: Color(0xFF454545)),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline),
                                      // color: Color(0xFF323232),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWithDivider(
                                          label: "Email",
                                          value: data.email,
                                          showDivider: true,
                                        ),
                                        CustomTextWithDivider(
                                          label: "Phone Number",
                                          value: data.phoneNum ?? "",
                                          showDivider: true,
                                        ),
                                        CustomTextWithDivider(
                                          label: "Date of Birth",
                                          value: data.dateOfBirth ?? " ",
                                          showDivider: true,
                                        ),
                                        CustomTextWithDivider(
                                          label: "Branch",
                                          value: data.branch,
                                          showDivider: true,
                                        ),
                                        CustomTextWithDivider(
                                          label: "Graduation Year",
                                          value: data.gradyear,
                                          showDivider: true,
                                        ),
                                        CustomTextWithDivider(
                                          label: "Division",
                                          value: data.div ?? "-",
                                          showDivider: true,
                                        ),
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
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Scrollbar(
                                            thumbVisibility: true,
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
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .outline,
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
                                                              .subtract(
                                                                  const Duration(
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
                                                        // const pattern =
                                                        //     r'^(-1[1-9]|[12][0-9]|3[01]) (January|February|March|April|May|June|July|August|September|October|November|December) \d{4}$';
                                                        // final regex =
                                                        //     RegExp(pattern);

                                                        // if (!regex
                                                        //     .hasMatch(value)) {
                                                        //   return 'Invalid Date Of Birth format. Please use the format: 19 August 2003';
                                                        // }

                                                        return null;
                                                      },
                                                      // initialValue: dob,
                                                      // onSaved: widget.onSaved ?? (val) {},
                                                    ),
                                                    ProfileTextField(
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
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter your Address';
                                                        }
                                                        return null;
                                                      },
                                                    ),

                                                    ProfileTextField(
                                                      // controller:
                                                      //     _addressController,

                                                      initVal: homeStation,
                                                      onSaved: (newVal) {
                                                        setState(() {
                                                          if (newVal != null) {
                                                            homeStation =
                                                                newVal;
                                                          }
                                                        });
                                                      },
                                                      label:
                                                          'Nearest Railway Station',
                                                      isEditMode: _isEditMode,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter the nearest railway station to your place';
                                                        }
                                                        return null;
                                                      },
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
                                                      enabled: false,
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
                                                      enabled: false,
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
                                                          child:
                                                              DropdownButtonFormField(
                                                            // Initial Value
                                                            value: div,
                                                            hint: const Text(
                                                              "Division",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),

                                                            // underline:
                                                            //     Container(
                                                            //   height: 1,
                                                            //   color: Theme.of(
                                                            //           context)
                                                            //       .colorScheme
                                                            //       .outline, // Change to your desired color
                                                            // ),
                                                            validator: (value) {
                                                              if (value == "") {
                                                                return 'Please enter a division';
                                                              }
                                                              return null;
                                                            },
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
                                                        const SizedBox(
                                                            width: 20),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  4, 5, 4, 5),
                                                          child:
                                                              DropdownButtonFormField(
                                                            // Initial Value
                                                            value: batch,

                                                            hint: const Text(
                                                              "Batch",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            // underline:
                                                            //     Container(
                                                            //   height: 1,
                                                            //   color: Theme.of(
                                                            //           context)
                                                            //       .colorScheme
                                                            //       .outline, // Change to your desired color
                                                            // ),

                                                            validator: (value) {
                                                              if (value == "") {
                                                                return 'Please enter a batch';
                                                              }
                                                              return null;
                                                            },
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
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Spacer(),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (_isEditMode) {
                                                    _saveChanges(ref);
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 15),
                                                  backgroundColor: Colors.green,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0), // Half of desired button height
                                                  ),
                                                ),
                                                child: Text(
                                                  "Save Changes",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      // isExpanded = false;
                                                      // isBlurred = false;
                                                      _isEditMode = false;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.cancel_outlined,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                    size: 30,
                                                  ), // Use Icon widget to specify the icon
                                                ),
                                              ),
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
              ? (widget.justLoggedIn
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Spacer(),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!_isEditMode) {
                                    // enableEditing();
                                    setState(() {
                                      // isExpanded = true;
                                      // isBlurred = true;
                                      _isEditMode = true;
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 1000), () {
                                      if (listScrollController.hasClients) {
                                        final position = listScrollController
                                            .position.viewportDimension;
                                        listScrollController.animateTo(
                                          position,
                                          duration: const Duration(seconds: 1),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                child: //Text(_isEditMode ? 'Save Changes' : 'Edit'),
                                    const Text("EDIT"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: 60,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (data.batch != null &&
                                        data.div != null) {
                                      GoRouter.of(context).go('/main');
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please fill in your details'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Icon(Icons.arrow_forward),
                                  style: ButtonStyle(
                                    // backgroundColor: MaterialStateProperty.all<Color>(
                                    //     Colors.transparent),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_isEditMode) {
                            // enableEditing();
                            setState(() {
                              // isExpanded = true;
                              // isBlurred = true;
                              _isEditMode = true;
                            });
                            Future.delayed(const Duration(milliseconds: 1000),
                                () {
                              if (listScrollController.hasClients) {
                                final position = listScrollController
                                    .position.viewportDimension;
                                listScrollController.animateTo(
                                  position,
                                  duration: const Duration(seconds: 1),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: //Text(_isEditMode ? 'Save Changes' : 'Edit'),
                            const Text("EDIT"),
                      ),
                    ))
              : Container(),
        ],
      ),
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
