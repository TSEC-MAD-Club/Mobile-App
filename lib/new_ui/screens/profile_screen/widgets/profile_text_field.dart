import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';

class ProfileField extends ConsumerStatefulWidget {
  String labelName;
  TextEditingController? controller;
  bool enabled;
  bool? readOnly;
  String? value;
  final onChanged;
  String? Function(String?)? validator;
  final onTap;

  ProfileField({
    super.key,
    this.readOnly,
    required this.labelName,
    required this.enabled,
    this.value,
    this.onChanged,
    this.controller,
    this.validator,
    this.onTap,
  });

  @override
  ConsumerState<ProfileField> createState() => _ProfileFieldState();
}

class _ProfileFieldState extends ConsumerState<ProfileField> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    UserModel? user = ref.watch(userModelProvider);
    return Container(
      height: 75,
      width: width * .95,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: widget.enabled
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                // color: Colors.black,
                width: user!.isStudent ? width * .25 : width * .34,
                child: Text(
                  widget.labelName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              // SizedBox(width: 10),
              Container(
                width: MediaQuery.of(context).size.width * .6,
                // color: Colors.black,
                // height: MediaQuery.of(context).size.height * .0,
                child: TextFormField(
                  maxLines: null,
                  minLines: 1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true),
                  enabled: widget.enabled,
                  controller: widget.controller,
                  // readOnly: readOnly ?? false,
                  initialValue: widget.value,
                  style: Theme.of(context).textTheme.bodySmall,
                  onChanged: widget.onChanged,
                  validator: widget.validator,
                  onTap: widget.onTap,
                  // maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
