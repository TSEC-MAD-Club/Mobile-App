import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';

import 'package:tsec_app/screens/profile_screen/widgets/profile_screen_appbar.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StudentModel? data = ref.watch(studentModelProvider);
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    _image != null
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/pfpholder.jpg"),
                          ),
                    Positioned(
                      bottom: 0,
                      right: -25,
                      child: RawMaterialButton(
                        onPressed: _editProfileImage,
                        elevation: 2.0,
                        // fillColor: const Color(0xFFF5F6F9),
                        fillColor: kLightModeShadowColor,
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.blue,
                        ),
                        padding: const EdgeInsets.all(6.0),
                        shape: const CircleBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _phoneNumController,
                label: 'Phone Number',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _branchController,
                label: 'Branch',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _gradyearController,
                label: 'Graduation Year',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _divController,
                label: 'Division',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _batchController,
                label: 'Batch',
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _editCount < 3 ? _saveChanges : null,
              //   child: const Text('Save Changes'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      enabled: false,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[900] ?? Colors.grey),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        labelText: label,
      ),
    );
  }

  void _editProfileImage() async {
    // Add your implementation for editing the profile image here
    // This function will be called when the edit button is pressed for the profile image
    // You can use plugins like `image_picker` to implement image selection and updating logic

    Uint8List image = await pickImage(ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  // void _saveChanges() async {
  //   final user = ref.read(userProvider.notifier).state;
  //   final StudentModel? data = ref.read(studentModelProvider.notifier).state;

  //   // Create a reference to the user's document in Firebase Firestore
  //   final userDoc =
  //       FirebaseFirestore.instance.collection('Students').doc(user!.uid);

  //   // Update the fields with the new values from the text controllers
  //   final updatedData = {
  //     'Name': _nameController.text,
  //     'email': _emailController.text,
  //     'Batch': _batchController.text,
  //     'Branch': _branchController.text.toUpperCase(),
  //     'div': _divController.text,
  //     'gradyear': _gradyearController.text,
  //     'phoneNo': _phoneNumController.text,
  //   };

  //   try {
  //     // Update the user's document with the new data
  //     await userDoc.set(updatedData, SetOptions(merge: true));

  //     // Fetch the updated data from Firebase
  //     final updatedUserData = await userDoc.get();
  //     final updatedStudentData = StudentModel.fromJson(updatedUserData.data()!);

  //     // Update the data in the studentModelProvider
  //     ref.read(studentModelProvider.notifier).state = updatedStudentData;

  //     // Increment the edit count
  //     setState(() {
  //       _editCount++;
  //     });

  //     // Show a success message or perform any additional actions
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Profile updated successfully')),
  //     );
  //   } catch (e) {
  //     // Handle any errors that occurred during the update process
  //     print('Error updating profile: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text('An error occurred. Please try again later.')),
  //     );
  //   }
  //}
}
