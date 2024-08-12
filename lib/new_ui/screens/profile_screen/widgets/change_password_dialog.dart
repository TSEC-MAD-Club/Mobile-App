import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tsec_app/provider/auth_provider.dart';

class ChangePasswordDialog extends ConsumerWidget {
  ChangePasswordDialog({super.key, required this.ctx1});
  BuildContext ctx1;

  final TextEditingController oldPasswordController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController = TextEditingController();

  String? validatePassword(){
    if(newPasswordController.text != confirmPasswordController.text){
      return "Passwords do not match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text('Change Password'),
      content: Container(
        //padding: const EdgeInsets.all(16),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   'Change Password',
              //   style: Theme.of(context).textTheme.headlineSmall,
              // ),
              const SizedBox(height: 16),
              TextFormField(
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                obscureText: true,
                controller: oldPasswordController,
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 12),
                  focusColor: Colors.red,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Old Password',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if(value != confirmPasswordController.text){
                    return "Passwords do not match";
                  }
                  return null;
                },
                style: TextStyle(color: Colors.white),
                obscureText: true,
                controller: newPasswordController,
                decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 12),
                    focusColor: Colors.red,
                    fillColor: Colors.transparent,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'New Password',
                  errorText: validatePassword()
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if(value != newPasswordController.text){
                    return "Passwords do not match";
                  }
                  return null;
                },
                style: TextStyle(color: Colors.white),
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 12),
                  focusColor: Colors.red,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Confirm Password',
                  errorText: validatePassword(),
                ),

              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        ref.watch(authProvider.notifier).changePassword(oldPasswordController.text, newPasswordController.text, ctx1);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Change'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
