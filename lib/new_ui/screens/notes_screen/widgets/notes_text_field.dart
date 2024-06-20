import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';

class NotesTextField extends ConsumerStatefulWidget {
  bool editMode;
  String label;
  TextEditingController? controller;
  bool readOnly;
  String? val;
  int? maxLines;

  String? Function(String?)? validator;
  final onTap;
  NotesTextField({
    super.key,
    this.validator,
    required this.editMode,
    required this.readOnly,
    required this.label,
    this.controller,
    this.val,
    this.maxLines,
    this.onTap,
  });

  @override
  ConsumerState<NotesTextField> createState() => _NotesTextFieldState();
}

class _NotesTextFieldState extends ConsumerState<NotesTextField> {
  @override
  Widget build(BuildContext context) {
    UserModel user = ref.watch(userModelProvider)!;
    return Padding(
      padding: widget.editMode
          ? const EdgeInsets.fromLTRB(20, 11, 20, 11)
          : EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: TextFormField(
        style: Theme.of(context).textTheme.bodySmall!.copyWith(height: user.isStudent ? 3: 1.5),
        controller: widget.controller,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        validator: widget.validator,
        initialValue: widget.val,
        enabled: widget.editMode,
        decoration: InputDecoration(
          // border: InputBorder.none,
          labelStyle: const TextStyle(
            color: Colors.grey,
            // height: 4
          ),
          // hintStyle: TextStyle(height: 7),
          labelText: widget.label,
        ),
      ),
    );
  }
}
