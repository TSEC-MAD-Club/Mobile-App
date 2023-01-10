import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/provider/auth_provider.dart';

import '../../main_screen/main_screen.dart';
import '../login_screen.dart';
import 'custom_login_widget.dart';

class SkipAndNextRow extends ConsumerWidget {
  const SkipAndNextRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onPressed: () {
                ref.watch(authProvider).signInUser(
                    ref.read(emailTextProvider.notifier).state,
                    ref.read(passwordTextProvider.notifier).state);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              child: const Icon(Icons.arrow_forward),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
