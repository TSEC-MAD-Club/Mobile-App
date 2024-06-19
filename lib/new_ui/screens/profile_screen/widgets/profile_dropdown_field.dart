import 'package:flutter/material.dart';

class ProfileDropdownField extends StatelessWidget {
  String text;
  bool editMode;
  String? val;
  List<String> valList;
  void Function(String?)? onChanged;
  String? Function(String?)? validator;
  ProfileDropdownField(
      {super.key,
      required this.editMode,
      required this.text,
      required this.val,
      required this.valList,
      required this.onChanged,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: editMode
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Row(
          children: [
            Text(
              // "Division",
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(width: 50),
            Container(
              width: MediaQuery.of(context).size.width * .45,
              child: DropdownButtonFormField(
                decoration: InputDecoration(border: InputBorder.none),
                // value: div,
                value: val,
                validator: validator,
                dropdownColor: Theme.of(context).colorScheme.background,
                // items: divisionList.map((String item) {
                items: valList.map((String item) {
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

                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
                // After selecting the desired option,it will
                // change button value to selected value
                // onChanged: editMode
                //     ? (String? newValue) {
                //         if (newValue != null) {
                //           setState(() {
                //             div = newValue;
                //             batchList = calcBatchList(newValue);
                //             batch = null;
                //           });
                //         }
                //       }
                //     : null,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
