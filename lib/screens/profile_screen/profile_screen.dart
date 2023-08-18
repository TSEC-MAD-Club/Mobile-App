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

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _divController = TextEditingController();
  final TextEditingController _gradyearController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _homeStationController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

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

  void _saveChanges(WidgetRef ref) async {
    final StudentModel? data = ref.watch(studentModelProvider);
    bool b = data!.updateCount != null ? data.updateCount! < 2 : true;
    if (b) {
      if (data.updateCount == null) {
        data.updateCount = 1;
      } else {
        int num = data.updateCount!;
        data.updateCount = num + 1;
      }
      StudentModel student = StudentModel(
          div: _divController.text,
          batch: _batchController.text,
          branch: convertFirstLetterToUpperCase(_branchController.text),
          name: _nameController.text,
          email: _emailController.text,
          gradyear: _gradyearController.text,
          phoneNum: _phoneNumController.text,
          updateCount: data.updateCount,
          address: _addressController.text,
          homeStation: _homeStationController.text,
          dateOfBirth: _dateOfBirthController.text);

      if (_formKey.currentState!.validate()) {
        ref
            .watch(authProvider.notifier)
            .updateUserDetails(student, ref, context);
        setState(() {
          _isEditMode = false;
          isExpanded = false;
          isBlurred = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'You have already updated your profile as many times as possible'),
        ),
      );
    }
  }

  bool isExpanded = false;
  bool isBlurred = false;

  @override
  Widget build(BuildContext context) {
    final StudentModel? data = ref.watch(studentModelProvider);
    debugPrint(data?.updateCount?.toString());
    _nameController.text = data!.name;
    _emailController.text = data.email;
    _batchController.text = data.batch;
    _branchController.text = data.branch.toUpperCase();
    _divController.text = data.div;
    _gradyearController.text = data.gradyear;
    _phoneNumController.text = data.phoneNum;
    _addressController.text = data.address ?? '';
    _homeStationController.text = data.homeStation ?? '';
    _dateOfBirthController.text = data.dateOfBirth ?? '';

    return CustomScaffold(
      appBar: const ProfilePageAppBar(title: "Profile"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                        bottom: -30,
                        child: Container(
                          width: 100, // Adjust the width and height as needed
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4, // Adjust the border width as needed
                            ),
                          ),
                          child: buildProfileImages(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Text(
                    data.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    // TODO: FIX this
                    'Location${data.homeStation ?? " "}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade800),
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: CustomTextWithDivider(
                            label: "Email",
                            value: data.email,
                          ),
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
                          label: "Batch",
                          value: data.batch,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade800,
                        ),
                        CustomTextWithDivider(
                          label: "Division",
                          value: data.div,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              isBlurred
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : const SizedBox.shrink(),
              _isEditMode
                  ? SingleChildScrollView(
                      child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width: 450,
                      height: 675,
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
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
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
                    ))
                  : Positioned(
                      bottom: 0,
                      left: 10,
                      right: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 100, right: 100),
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
                          child: const Text("EDIT"),
                        ),
                      )),
              const SizedBox(height: 20),
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
                radius: 60,
                backgroundImage: MemoryImage(_image!),
              )
            : const CircleAvatar(
                radius: 60,
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
