import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
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
                          onPressed: _isEditing ? _editProfileImage : null,
                          elevation: 2.0,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
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
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _phoneNumController,
                  label: 'Phone Number',
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
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _branchController,
                  label: 'Branch',
                  enabled: false,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _gradyearController,
                  label: 'Graduation Year',
                  enabled: false,
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
                  enabled: _isEditing,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isEditing ? _saveChanges : _enableEditing,
                  child: Text(_isEditing ? 'Save Changes' : 'Edit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing && enabled,
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
      validator: validator,
    );
  }

  void _enableEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _editProfileImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  void _saveChanges() async {
    final user = ref.read(userProvider.notifier).state;
    final StudentModel? data = ref.read(studentModelProvider.notifier).state;

    final userDoc =
        FirebaseFirestore.instance.collection('Students ').doc(user!.uid);

    final updatedData = {
      'Name': _nameController.text,
      'email': _emailController.text,
      'div': _divController.text,
      'phoneNo': _phoneNumController.text,
      'Batch': _batchController.text,
    };

    if (_formKey.currentState!.validate()) {
      try {
        await userDoc.set(updatedData, SetOptions(merge: true));

        final updatedUserData = await userDoc.get();
        final updatedStudentData =
            StudentModel.fromJson(updatedUserData.data()!);

        ref.read(studentModelProvider.notifier).state = updatedStudentData;

        setState(() {
          _editCount++;
          _isEditing = false;
          print(_editCount);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An error occurred. Please try again later.')),
        );
      }
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phoneNumber);
  }
}
