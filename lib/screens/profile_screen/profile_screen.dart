import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/screens/profile_screen/widgets/profile_screen_appbar.dart';

import '../../models/student_model/student_model.dart';
import '../../provider/auth_provider.dart';
import '../../widgets/custom_scaffold.dart';

bool isEnable = false;

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

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

  @override
  void initState() {
    super.initState();
    isEnable = false;
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
            child: Column(children: [
              SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/pfpholder.jpg"),
                    ),
                    Positioned(
                        bottom: 0,
                        right: -25,
                        child: RawMaterialButton(
                          onPressed: () {},
                          elevation: 2.0,
                          fillColor: const Color(0xFFF5F6F9),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(15.0),
                          shape: const CircleBorder(),
                        )),
                  ],
                ),
              ),
              // Text(data.name),
              // Text(data.email),
              // Text(data.batch),
              // Text(data.branch),
              // Text(data.div),
              // Text(data.gradyear),
              // Text(data.phoneNum),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _nameController,
                enabled: isEnable,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Colors.grey, // Set the label color here
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[900] ?? Colors.grey),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  labelText: 'Name',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _emailController,
                enabled: false,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Colors.grey, // Set the label color here
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[900] ?? Colors.grey),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _phoneNumController,
                enabled: isEnable,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Colors.grey, // Set the label color here
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[900] ?? Colors.grey),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  labelText: 'Phone Number',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _branchController,
                enabled: false,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Colors.grey, // Set the label color here
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[900] ?? Colors.grey),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  labelText: 'Branch',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _gradyearController,
                enabled: false,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Colors.grey, // Set the label color here
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[900] ?? Colors.grey),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  labelText: 'Graduation Year',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _divController,
                enabled: isEnable,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Colors.grey, // Set the label color here
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[900] ?? Colors.grey),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  labelText: 'Division',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _batchController,
                enabled: isEnable,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Colors.grey, // Set the label color here
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[900] ?? Colors.grey),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  labelText: 'Batch',
                ),
              ),
            ]),
          ),
        ));
  }
}
