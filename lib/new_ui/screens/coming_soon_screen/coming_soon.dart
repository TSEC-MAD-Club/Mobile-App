import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tsec_app/new_ui/screens/main_screen/widgets/common_basic_appbar.dart';

class ComingSoon extends StatefulWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  _ComingSoonState createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  final List<String> imgList = [
    'assets/images/coming_soon/coming_soon_1.png',
    'assets/images/coming_soon/coming_soon_2.png',
  ];  

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_current < imgList.length - 1) {
        _current++;
      } else {
        _current = 0;
      }

      _controller.animateToPage(_current);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(),
      body: Stack(
        children: [
          CarouselSlider(
            items: imgList.map((item) => Image.asset(
              item,
              fit: BoxFit.cover,
              width: double.infinity,
            )).toList(),
            carouselController: _controller,
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlay: false,
            ),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   "What are we working on 🤔",
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .bodyLarge!
                  //       .copyWith(color: Colors.white),
                  // ),
                  SizedBox(height: 0.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    height: MediaQuery.of(context).size.width * .60,
                    child: Lottie.asset("assets/animation/coming_soon_lottie.json"),
                  ),
                  SizedBox(height: 50.0),
                  Text(
                    "Hold up!\nexciting updates are on the way!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
