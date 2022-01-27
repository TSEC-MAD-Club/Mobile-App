import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../provider/app_state_provider.dart';

class SkipAndNextRow extends ConsumerWidget {
  const SkipAndNextRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 70,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ref.read(appStateProvider.notifier).appOpened().then((_) {
                  GoRouter.of(context).push("/");
                });
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
