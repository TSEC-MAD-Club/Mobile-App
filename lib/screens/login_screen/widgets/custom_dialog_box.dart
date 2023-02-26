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
    final _theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .45,
        width: double.infinity,
        child: Card(
          color: _theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 20,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                        fontFamily: "Lato",
                        color: _theme.cardColor,
                        letterSpacing: 2.0,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 25,
                  ),
                  child: Text(
                    "Enter new password ",
                    style: TextStyle(
                      fontSize: 18,
                      color: _theme.cardColor,
                      fontFamily: "Outline",
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .07,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _passwordTextEditingController,
                      style: TextStyle(
                        color: _theme.cardColor,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _theme.cardColor,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: (Theme.of(context).primaryColor ==
                                    const Color(0xFFF2F5F8))
                                ? Colors.black54
                                : Colors.white38,
                            width: .5,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        filled: true,
                        hintStyle: TextStyle(
                          color: (Theme.of(context).primaryColor ==
                                  const Color(0xFFF2F5F8))
                              ? Colors.grey[500]
                              : Colors.white60,
                        ),
                        hintText: "Enter Your Password",
                        fillColor: _theme.primaryColor,
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
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .06,
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
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w400,
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
