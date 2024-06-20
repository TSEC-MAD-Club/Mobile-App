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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.isStudent)
            SizedBox(
              height: 20,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          DropdownButtonFormField(
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
            value: widget.val,
            validator: widget.validator,
            decoration: InputDecoration(
              border: !user.isStudent ? UnderlineInputBorder() : InputBorder.none,
              labelStyle: const TextStyle(
                color: Colors.grey,
              ),
              labelText: user.isStudent ? null : widget.label,
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
        ],
      ),
    );
  }
}
