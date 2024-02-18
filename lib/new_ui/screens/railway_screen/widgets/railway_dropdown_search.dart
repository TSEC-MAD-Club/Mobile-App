import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class RailwayDropdownSearch extends StatelessWidget {
  bool editMode;
  String label;
  String val;
  String? Function(String?)? validator;
  final onChanged;
  List<String> items;

  RailwayDropdownSearch({
    super.key,
    required this.editMode,
    required this.label,
    required this.val,
    this.onChanged,
    required this.items,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // debugPrint("RailwayDropdownSearch: $val");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: editMode
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.outline,
            width: .5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
          child: DropdownSearch<String>(
            enabled: editMode,
            validator: validator,
            selectedItem: val,
            dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
              dropdownSearchDecoration: InputDecoration(
                fillColor: Colors.white,
                labelText: label,
                labelStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
            popupProps: PopupProps.dialog(
              showSearchBox: true,
              // itemBuilder: ()
              itemBuilder: (context, item, isSelected) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: Text(
                      item,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                );
              },
              containerBuilder: (context, popupWidget) {
                return Container(
                    color: Theme.of(context).colorScheme.background,
                    child: popupWidget);
              },
              // itemBuilder: (context, item, isSelected) {
              //   return Container(
              //     child: Text(item),
              //   );
              // }),
            ),
            dropdownButtonProps: DropdownButtonProps(
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
              ),
              alignment: Alignment.bottomRight,
            ),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
