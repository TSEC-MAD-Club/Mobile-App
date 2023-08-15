import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
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
    // final user = ref.read(userProvider.notifier).state;
    // final StudentModel? data = ref.read(studentModelProvider.notifier).state;
    //
    // final userDoc =
    //     FirebaseFirestore.instance.collection('Students ').doc(user!.uid);
    //
    // final updatedData = {
    //   'Name': _nameController.text,
    //   'email': _emailController.text,
    //   'div': _divController.text,
    //   'phoneNo': _phoneNumController.text,
    //   'Batch': _batchController.text,
    // };

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
      );

      if (_formKey.currentState!.validate()) {
        ref
            .watch(authProvider.notifier)
            .updateUserDetails(student, ref, context);
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
    return CustomScaffold(
      appBar: const ProfilePageAppBar(title: "Profile"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
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
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 380,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileTextField(
                            isEditMode: _isEditMode,
                            label: "Email",
                            controller: _emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an email';
                              }
                              if (!isValidEmail(value)) {
                                return 'Please enter a valid email';
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
                            // enabled: false,
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
                        ]),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_isEditMode) {
                      _saveChanges(ref);
                    } else {
                      enableEditing();
                    }
                  },
                  child: Text(_isEditMode ? 'Save Changes' : 'Edit'),
                ),
              ],
            ),
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
