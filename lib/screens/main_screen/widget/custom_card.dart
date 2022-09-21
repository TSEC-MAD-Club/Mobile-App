import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(this.color, this.opacityColor, {Key? key}) : super(key: key);
  final Color? color;
  final Color? opacityColor;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    var _theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(
        bottom: 30.0,
      ),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        child: Container(
          height: _size.height * 0.16,
          decoration: BoxDecoration(
            color: _theme.primaryColor,
            borderRadius: BorderRadius.circular(
              15.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 12.0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(
                      15.0,
                    ),
                  ),
                ),
              ),
              Container(
                width: 85.0,
                decoration: BoxDecoration(
                  color: opacityColor,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '09:45 AM',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _theme.textTheme.headline1!.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          letterSpacing: 1.0,
                          wordSpacing: 3.0,
                        ),
                      ),
                      Text(
                        '24/06/2022 Thursday',
                        style: TextStyle(
                          color: _theme.textTheme.headline1!.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]),
              ),
              Container(
                width: _size.width * 0.56,
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 8.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lorem Ipsum',
                      style: TextStyle(
                        color: _theme.textTheme.headline1!.color,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      'Lorem ipsum is placeholder text commonly used ,...',
                      style: TextStyle(
                        color: _theme.textTheme.headline1!.color,
                        fontSize: 13.5,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 14.0,
                          backgroundImage: NetworkImage(
                              'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.0l7k5zqRUVQ5Yq9eTpW2LgHaLJ%26pid%3DApi&f=1'),
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          'Dr. Ashwin Kunte',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
