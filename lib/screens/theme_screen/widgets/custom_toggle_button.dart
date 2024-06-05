import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/provider/theme_provider.dart';

import '../../../utils/themes.dart';

class CustomToggleButton extends ConsumerStatefulWidget {
  final List<String> values;
  final VoidCallback onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final List<BoxShadow> shadows;

  const CustomToggleButton({
    Key? key,
    required this.values,
    required this.onToggleCallback,
    this.backgroundColor = const Color(0xFFD8D5D5),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
    this.shadows = const [
      BoxShadow(
        color: Color(0xFFd8d7da),
        spreadRadius: 5,
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  }) : super(key: key);

  @override
  _CustomToggleButtonState createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends ConsumerState<CustomToggleButton> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final _theme = ref.watch(themeProvider);
    return Container(
      width: width * 0.7,
      height: width * 0.13,
      margin: const EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: widget.onToggleCallback,
            child: Container(
              width: width * 0.7,
              height: width * 0.13,
              decoration: ShapeDecoration(
                color: _theme == ThemeMode.light
                    ? kLightModeToggleBtnBg
                    : kDarkModeToggleBtnBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.values.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: Text(
                      widget.values[index],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment: _theme == ThemeMode.light
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: width * 0.35,
              height: width * 0.13,
              decoration: ShapeDecoration(
                color: Theme.of(context).primaryColorLight,
                shadows: _theme == ThemeMode.light
                    ? shadowLightModeToggleBtn
                    : shadowDarkModeToggleBtn,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.1),
                ),
              ),
              child: Text(
                _theme == ThemeMode.light ? widget.values[0] : widget.values[1],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
