import 'package:flutter/material.dart';
import 'package:tsec_app/utils/themes.dart';

class SkipAndNextRow extends StatelessWidget {
  const SkipAndNextRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Text(
              "Skip",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 70,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                tooltip: 'Increase volume by 10',
                onPressed: () {},
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kLightModeLightBlue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ))),
            ),
          ),
        ],
      ),
    );
  }
}
