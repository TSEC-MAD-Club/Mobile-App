import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';

class NotesDropdownField extends ConsumerStatefulWidget {
  bool editMode;
  String label;
  String? val;
  String? Function(String?)? validator;
  final onChanged;
  List<String> items;

  NotesDropdownField(
      {super.key,
      required this.editMode,
      required this.label,
      this.val,
      this.onChanged,
      required this.items,
      this.validator});

  @override
  ConsumerState<NotesDropdownField> createState() => _NotesDropdownFieldState();
}

class _NotesDropdownFieldState extends ConsumerState<NotesDropdownField> {

  @override
  Widget build(BuildContext context) {
    UserModel user = ref.watch(userModelProvider)!;
    return Padding(
      padding: !user.isStudent
          ? const EdgeInsets.fromLTRB(20, 11, 20, 11)
          : EdgeInsets.fromLTRB(15, 0, 15, 0),
      // padding: EdgeInsets.fromLTRB(20, 11, 20, 11),
      child: DropdownButtonFormField(
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white),
        // style: Theme.of(context).textTheme.bodySmall,
        value: widget.val,
        validator: widget.validator,
        decoration: InputDecoration(
          border: !user.isStudent ? UnderlineInputBorder() : InputBorder.none,
          // border: UnderlineInputBorder(),
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          labelText: widget.label,
        ),
        icon: widget.editMode ? Icon(Icons.keyboard_arrow_down) : Icon(null),
        dropdownColor: Theme.of(context).colorScheme.background,
        items: widget.items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }).toList(),
        onChanged: widget.editMode ? widget.onChanged : null,
      ),
    );
  }
}
