import 'package:flutter/material.dart';

class CustomToggleButton extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final List<BoxShadow> shadows;

  const CustomToggleButton({
    Key? key,
    required this.values,
    required this.onToggleCallback,
    this.backgroundColor = const Color(0xFFe7e7e8),
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

class _CustomToggleButtonState extends State<CustomToggleButton> {
  bool initialPosition = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.7,
      height: width * 0.13,
      margin: const EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              debugPrint("hello");
              initialPosition = !initialPosition;
              var index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
              setState(() {});
            },
            child: Container(
              width: width * 0.7,
              height: width * 0.13,
              decoration: ShapeDecoration(
                color: widget.backgroundColor,
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
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF918f95),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
                initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: width * 0.35,
              height: width * 0.13,
              decoration: ShapeDecoration(
                color: Theme.of(context).primaryColor,
                shadows: widget.shadows,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.1),
                ),
              ),
              child: Text(
                initialPosition ? widget.values[0] : widget.values[1],
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: width * 0.045,
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
