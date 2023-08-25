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
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/screens/profile_screen/widgets/custom_text_with_divider.dart';
import 'package:tsec_app/screens/profile_screen/widgets/profile_screen_appbar.dart';
import 'package:tsec_app/screens/profile_screen/widgets/profile_text_field.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';
import '../../utils/image_pick.dart';
import '../../utils/themes.dart';
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

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
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
  Future editProfileImage() async {
    // setState(() {
    //   loadingImage = true;
    // });
    Uint8List? image = await pickImage(ImageSource.gallery);
    if (image != null) {
      await ref.watch(authProvider.notifier).updateProfilePic(image);
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
    final StudentModel? data = ref.watch(studentModelProvider);
    bool b = data!.updateCount != null ? data.updateCount! < 2 : true;
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
        await ref.watch(authProvider.notifier).updateUserDetails(student, ref, context);
        setState(() {
          _isEditMode = false;
        });
        return true;
      }
      return false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have already updated your profile as many times as possible'),
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
    final StudentModel? data = ref.read(studentModelProvider);
    name = data!.name;
    email = data.email;
    batch = data.batch;
    branch = data.branch;
    div = data.div;
    gradyear = data.gradyear;
    batch = data.batch;
    phoneNum = data.phoneNum;
    address = data.address ?? '';
    homeStation = data.homeStation ?? '';
    _dobController.text = data.dateOfBirth ?? "";
    calcBatchList(data.div);
    calcDivisionList(data.gradyear);
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
                fillColor: Color(0xFFF5F6F9),
                child: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                padding: EdgeInsets.all(3.0),
                shape: CircleBorder(side: BorderSide(color: Colors.black)),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final StudentModel? data = ref.watch(studentModelProvider);

    bool hide = widget.justLoggedIn || _isEditMode;
    // bool hide = _isEditMode;
    return CustomScaffold(
      hideButton: hide,
      //fuck the app bar and the floating action button
      appBar: const ProfilePageAppBar(title: "Profile"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          child: Stack(
            alignment: Alignment.center,
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
                          height: 150,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/tsecImages.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        child: Container(
                          width: 100, // Adjust the width and height as needed
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 4, // Adjust the border width as needed
                            ),
                          ),
                          child: buildProfileImages(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    data.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  // TODO: Add HomeStation ex : Virar
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade800),
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWithDivider(
                          label: "Email",
                          value: data.email,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade800,
                        ),
                        CustomTextWithDivider(
                          label: "Phone Number",
                          value: data.phoneNum,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade800,
                        ),
                        CustomTextWithDivider(
                          label: "Date of Birth",
                          value: data.dateOfBirth ?? " ",
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade800,
                        ),
                        CustomTextWithDivider(
                          label: "Branch",
                          value: data.branch,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade800,
                        ),
                        CustomTextWithDivider(
                          label: "Graduation Year",
                          value: data.gradyear,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade800,
                        ),
                        CustomTextWithDivider(
                          label: "Division",
                          value: data.div,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade800,
                        ),
                        CustomTextWithDivider(
                          label: "Batch",
                          value: data.batch,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              isBlurred
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : const SizedBox.shrink(),
              Positioned(
                bottom: 0,
                left: 10,
                right: 10,
                child: Form(
                  key: _formKey,
                  child: isExpanded
                      ? AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          width: 500,
                          height: 680,
                          //padding: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade800),
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                ProfileTextField(
                                  isEditMode: _isEditMode,
                                  label: "Name",
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a name';
                                    }
                                    return null;
                                  },
                                ),
                                ProfileTextField(
                                  isEditMode: _isEditMode,
                                  label: "Email",
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter an email';
                                    }
                                    if (!isValidEmail(value)) {
                                      return 'Please enter a Valid Email';
                                    }
                                    return null;
                                  },
                                ),
                                ProfileTextField(
                                  controller: _addressController,
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
                                  controller: _homeStationController,
                                  label: 'Home Station',
                                  isEditMode: _isEditMode,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Home Station';
                                    }
                                    return null;
                                  },
                                ),
                                ProfileTextField(
                                  controller: _dateOfBirthController,
                                  label: 'Date of Birth',
                                  isEditMode: _isEditMode,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter Date Of Birth';
                                    }
                                    // Regular expression to match the desired DOB format: 20 August 2003
                                    const pattern =
                                        r'^(0[1-9]|[12][0-9]|3[01]) (January|February|March|April|May|June|July|August|September|October|November|December) \d{4}$';
                                    final regex = RegExp(pattern);

                                    if (!regex.hasMatch(value)) {
                                      return 'Invalid Date Of Birth format. Please use the format: 20 August 2003';
                                    }

                                    return null;
                                  },
                                ),
                                ProfileTextField(
                                  isEditMode: _isEditMode,
                                  label: "Phone Number",
                                  controller: _phoneNumController,
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
                                ProfileTextField(
                                  isEditMode: _isEditMode,
                                  label: "Branch",
                                  controller: _branchController,
                                  enabled: false,
                                ),
                                ProfileTextField(
                                  isEditMode: _isEditMode,
                                  label: "Graduation Year",
                                  controller: _gradyearController,
                                  enabled: false,
                                ),
                                ProfileTextField(
                                  isEditMode: _isEditMode,
                                  label: "Division",
                                  controller: _divController,
                                ),
                                ProfileTextField(
                                  isEditMode: _isEditMode,
                                  label: "Batch",
                                  controller: _batchController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a batch';
                                    }
                                    if (value.length != 3) {
                                      return 'Batch should be a single capital letter followed by two digits';
                                    }
                                    final batchRegex = RegExp(r'^[A-Z][0-9]{2}$');
                                    if (!batchRegex.hasMatch(value)) {
                                      return 'Batch should be a single capital letter followed by two digits';
                                    }
                                    return null;
                                  },
                                  enabled: _isEditMode,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          if (_isEditMode) {
                                            _saveChanges(ref);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                        child: const Text(
                                          "Save Changes",
                                        )),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isExpanded = false;
                                          isBlurred = false;

                                          _isEditMode = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      ), // Use Icon widget to specify the icon
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                              onPressed: () {
                                if (!_isEditMode) {
                                  enableEditing();
                                  setState(() {
                                    isExpanded = true;
                                    isBlurred = true;
                                    _isEditMode = true;
                                  });
                                }
                              },
                              child: //Text(_isEditMode ? 'Save Changes' : 'Edit'),
                                  const Text("EDIT")),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
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
              Icons.add_a_photo,
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
