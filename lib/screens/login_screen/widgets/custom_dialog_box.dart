import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsec_app/provider/auth_provider.dart';

class ChangePasswordDialog extends ConsumerStatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  ConsumerState<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _passwordTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
                child: const Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 15,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Change\nPassword",
                      style: TextStyle(
                          fontFamily: "Lato",
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                    top: 20,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Enter your new password ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontFamily: "Outline",
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      controller: _passwordTextEditingController,
                      decoration: const InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: TextStyle(
                          color: Colors.black26,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter the passoword";
                        if (value.length < 6)
                          return "The length of password is less than 6";

                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 35,
                    left: 12,
                    right: 12,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height *.05,
                      width: MediaQuery.of(context).size.width * .6,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref.watch(authProvider.notifier).changePassword(
                                _passwordTextEditingController.text.trim(),
                                context);
                            GoRouter.of(context).go('/main');
                          }
                        },
                        child:const  FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("Submit", 
                          style: TextStyle(
                            fontSize: 14, 
                          ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
