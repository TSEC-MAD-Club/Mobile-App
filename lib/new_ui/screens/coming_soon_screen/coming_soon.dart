import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tsec_app/new_ui/screens/main_screen/widgets/common_basic_appbar.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
        ],
        body: Padding(
          padding: EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Can you guess what we're working on?🤔",
                  style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                ),
                SizedBox(height: 40.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  height: MediaQuery.of(context).size.width * .60,
                  child: Lottie.asset("assets/animation/coming_soon_lottie.json")
                ),
                SizedBox(height: 40.0),
                Text(
                  "Do you love creating or solving? 🛠️🧩",
                  style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                ),
                SizedBox(height: 50.0),
                Text(
                  "Hold up... something interesting is on the way! 🚀 😉",
                  style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}